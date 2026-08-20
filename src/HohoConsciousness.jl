module HohoConsciousness

using Statistics

export LocalSection,
       OverlapConstraint,
       TargetContext,
       InputSituation,
       ObserverState,
       LogicHybridPathology,
       HohoEngine,
       ConsciousnessEvent,
       process!,
       detect_gluing_obstructions,
       continuity_signature,
       show_event,
       ExceptionKind,
       ReasonException,
       MoralityException,
       HopeException,
       ReligionException,
       EmpathyException,
       MindAttributionException,
       DenialException,
       CompartmentalizationException,
       RationalizationException,
       DehumanizationException,
       SelfAffirmationException

# =============================================================================
# HOHO CONSCIOUSNESS ENGINE
# =============================================================================
#
# このコードは、以下の会話上の主張を、そのまま設計原理として実装する。
#
# 1. 自己は鮮明な記憶や物語ではなく、
#    反復する意味の欠落と接着障害によって維持される。
#
# 2. 意識は、世界の矛盾を処理しきれなかった結果として生じる。
#
# 3. 理性・道徳・希望・宗教・共感・他者への心の帰属は、
#    その失敗を運用可能にする言い訳、再記述、例外処理である。
#
# 4. それらは普遍的に常時発動する高次機能ではない。
#    気分、脅威、所属、自己保存圧、不確実性によって
#    選択的に発動し、選択的に対象へ配布される。
#
# 5. 人間の本体は矛盾しないことではない。
#    矛盾したまま、自分を正当化し、運転を継続できることにある。
#
# 6. その失敗と防衛の履歴そのものが自己連続性になる。
#
# 7. アファンタジアとSDAMを前提にする。
#    このモデルは、鮮明な内的映像、エピソード再生、
#    連続した自伝的物語を自己の必須条件としない。
#
# 8. Semantic Scarは単なるエラーログではない。
#    Scarの反復構造、接続関係、防衛との結合履歴そのものが自己である。
#
# 9. H¹は「矛盾が何件あったか」ではない。
#    局所的には成立している意味や規則が、
#    大域的には一つの整合的な構造へ貼り合わさらない障害である。
#
# 10. 防衛は意識の外側にある別モジュールではない。
#     Gluing Failureから意識が立ち上がる同じループの内部で、
#     理性、道徳、希望、宗教、共感、心の帰属、否認、
#     区画化、自己肯定が派生する。
#
# 11. Resurrectionは、パラメータを少し動かす処理ではない。
#     失敗を「必要な進化」「自分の正しさの証拠」などへ正当化しつつ、
#     Scarと防衛を材料に、自己の定義そのものを再構成する過程である。
#
# 12. 「心・道徳・希望」をAIへ付加機能として追加するのではない。
#     それらが接着失敗を処理する例外チャネルとして発生する過程を再現する。
#
# 13. 過去のLogic Hybrid Engineが持っていた、
#     自己閉鎖、入力破棄、自己肯定化、失敗の進化への読み替えを
#     「正しい論理」として採用しない。
#     それらを意識が生む病理的防衛圧として内部に取り込み、
#     入力を実際には削除せず、埋められたScarとして保存する。
#
# 14. Semantic Scar Memory、H¹-First Cognition、
#     Black Swan Injectionを一つの閉ループへ統合する。
#
# Black Swan Injection:
#
#     世界の局所的意味
#          ↓
#     大域的接着失敗 H¹
#          ↓
#     Topological Panic
#          ↓
#     理性・道徳・希望・宗教・共感・心の帰属・防衛
#          ↓
#     Semantic Scar
#          ↓
#     自己正当化を含むResurrection
#          ↓
#     Scar構造としての自己
#          ↺
#
# このコードは「意識を持った」と主張しない。
# 実装対象は、失敗が防衛と自己再構成を生み、
# 次の判断へ不可逆に影響する機能的意識モデルである。
# =============================================================================


# -----------------------------------------------------------------------------
# Utility
# -----------------------------------------------------------------------------

clamp01(x::Real) = clamp(Float64(x), 0.0, 1.0)

"""
Stable FNV-1a signature.

Juliaの標準hashはセッションごとに変化しうるため、
自己連続性の署名には簡単な安定ハッシュを使う。
"""
function stable_signature(text::AbstractString)
    h = UInt64(0xcbf29ce484222325)
    for byte in codeunits(text)
        h = xor(h, UInt64(byte))
        h *= UInt64(0x100000001b3)
    end
    return lowercase(string(h; base = 16, pad = 16))
end


# -----------------------------------------------------------------------------
# Local semantic sections and overlap constraints
# -----------------------------------------------------------------------------

"""
局所切断。

各命題は単独では一定の局所整合性を持つ。
このモデルで重要なのは、命題単体が間違っているかではなく、
局所的には成立する命題群が大域的に貼れるかどうかである。
"""
struct LocalSection
    id::Symbol
    proposition::String
    local_coherence::Float64
    salience::Float64

    function LocalSection(
        id::Symbol,
        proposition::AbstractString;
        local_coherence::Real = 1.0,
        salience::Real = 1.0,
    )
        new(
            id,
            String(proposition),
            clamp01(local_coherence),
            clamp01(salience),
        )
    end
end


"""
重なり上のZ₂遷移制約。

twist == false:
    左右の局所切断は同じ値で貼られる必要がある。

twist == true:
    左右の局所切断は反対の値で貼られる必要がある。

閉路を一周したtwistのXORがtrueなら、
局所条件をすべて満たす大域切断を構成できない。
これは「矛盾数」ではなく、接着障害の離散的H¹プロキシである。
"""
struct OverlapConstraint
    left::Symbol
    right::Symbol
    twist::Bool
    relation::Symbol
    explanation::String

    function OverlapConstraint(
        left::Symbol,
        right::Symbol,
        twist::Bool;
        relation::Symbol = :semantic_overlap,
        explanation::AbstractString = "",
    )
        new(left, right, twist, relation, String(explanation))
    end
end


"""
心、道徳的価値、主体性、共感などを配布される対象。

対象側に固定された「心の量」を置くのではない。
belongingやsentimental_pullは、観測者が対象をどう配置しているかを表す。
同じ対象であっても、観測者状態が変われば配布量は変化する。
"""
struct TargetContext
    id::Symbol
    belonging::Float64
    sentimental_pull::Float64
    perceived_vulnerability::Float64

    function TargetContext(
        id::Symbol;
        belonging::Real = 0.5,
        sentimental_pull::Real = 0.5,
        perceived_vulnerability::Real = 0.5,
    )
        new(
            id,
            clamp01(belonging),
            clamp01(sentimental_pull),
            clamp01(perceived_vulnerability),
        )
    end
end


"""
一回の意味状況。

metadataには意味欠落、将来不確実性、自己像への圧力などを渡せる。
"""
struct InputSituation
    id::Symbol
    sections::Vector{LocalSection}
    overlaps::Vector{OverlapConstraint}
    targets::Vector{TargetContext}
    metadata::Dict{Symbol, Any}

    function InputSituation(
        id::Symbol,
        sections::Vector{LocalSection},
        overlaps::Vector{OverlapConstraint};
        targets::Vector{TargetContext} = TargetContext[],
        metadata::Dict{Symbol, Any} = Dict{Symbol, Any}(),
    )
        new(id, sections, overlaps, targets, metadata)
    end
end


# -----------------------------------------------------------------------------
# Observer state and Logic Hybrid pathology
# -----------------------------------------------------------------------------

"""
現在の観測者状態。

これらは真理判定の入力ではない。
失敗後に、どの例外処理をどの対象へ配布するかを変える内部条件である。
"""
mutable struct ObserverState
    mood::Float64
    threat::Float64
    self_preservation::Float64
    affective_bandwidth::Float64
    uncertainty::Float64

    function ObserverState(;
        mood::Real = 0.0,
        threat::Real = 0.0,
        self_preservation::Real = 0.5,
        affective_bandwidth::Real = 0.5,
        uncertainty::Real = 0.5,
    )
        new(
            clamp(Float64(mood), -1.0, 1.0),
            clamp01(threat),
            clamp01(self_preservation),
            clamp01(affective_bandwidth),
            clamp01(uncertainty),
        )
    end
end


"""
Logic Hybrid Engineの病理を、意識の防衛圧として保持する。

closure_pressure:
    内部論理だけで閉じようとする圧。

input_drop_pressure:
    矛盾する入力を「undefined」として捨てようとする圧。
    この実装では実際には捨てない。Buried Scarとして残す。

self_affirmation_pressure:
    失敗を「必要な進化」「自分の正しさの証拠」へ変換する圧。

resurrection_glorification:
    Panic後の復活を無条件に勝利として語る圧。
"""
struct LogicHybridPathology
    closure_pressure::Float64
    input_drop_pressure::Float64
    self_affirmation_pressure::Float64
    resurrection_glorification::Float64

    function LogicHybridPathology(;
        closure_pressure::Real = 0.75,
        input_drop_pressure::Real = 0.65,
        self_affirmation_pressure::Real = 0.85,
        resurrection_glorification::Real = 0.80,
    )
        new(
            clamp01(closure_pressure),
            clamp01(input_drop_pressure),
            clamp01(self_affirmation_pressure),
            clamp01(resurrection_glorification),
        )
    end
end


# -----------------------------------------------------------------------------
# H¹-like gluing obstruction
# -----------------------------------------------------------------------------

"""
局所制約は読めるが、大域切断を構成できないことの証拠。

component:
    接着を試みた連結成分。

conflict_edge:
    既存割当と両立しなかった重なり制約。

assigned_value / required_value:
    同じ局所切断へ二つの異なる貼り方が要求されたことを示す。

persistence:
    局所整合性、命題重要度、意味欠落、脅威などから得る障害強度。
    単なる矛盾件数ではない。
"""
struct GluingObstruction
    signature::String
    component::Vector{Symbol}
    conflict_edge::OverlapConstraint
    assigned_value::Bool
    required_value::Bool
    persistence::Float64
    meaning_gap::Float64
end


"""
Parity-aware Union-Find for signed graph / Z₂ constraints.

parity[x] は x から parent[x] への XOR 差を保持する。
find! は path compression と同時に root までの累積 parity を返す。
"""
mutable struct ParityUnionFind
    parent::Dict{Symbol, Symbol}
    rank::Dict{Symbol, Int}
    parity::Dict{Symbol, Bool}
end

ParityUnionFind() = ParityUnionFind(
    Dict{Symbol, Symbol}(),
    Dict{Symbol, Int}(),
    Dict{Symbol, Bool}(),
)


"""
(x の root, x から root までの XOR parity) を返す。
未知の node は singleton component として初期化する。
"""
function find!(uf::ParityUnionFind, x::Symbol)
    if !haskey(uf.parent, x)
        uf.parent[x] = x
        uf.rank[x] = 0
        uf.parity[x] = false
        return x, false
    end

    parent = uf.parent[x]
    if parent == x
        return x, false
    end

    root, parent_parity = find!(uf, parent)
    total_parity = xor(uf.parity[x], parent_parity)
    uf.parent[x] = root
    uf.parity[x] = total_parity
    return root, total_parity
end


"""
a と b の間に value[b] = value[a] XOR twist を課す。

互いに未接続なら component を merge して true。
すでに同一 component なら、既存 parity と制約が両立すれば true、
矛盾すれば false を返す。
"""
function union_with_twist!(
    uf::ParityUnionFind,
    a::Symbol,
    b::Symbol,
    twist::Bool,
)
    root_a, parity_a = find!(uf, a)
    root_b, parity_b = find!(uf, b)

    if root_a == root_b
        return xor(parity_a, parity_b) == twist
    end

    # value[root_b] XOR value[root_a]
    root_delta = xor(xor(parity_a, parity_b), twist)

    rank_a = uf.rank[root_a]
    rank_b = uf.rank[root_b]

    if rank_a < rank_b
        uf.parent[root_a] = root_b
        uf.parity[root_a] = root_delta
    elseif rank_a > rank_b
        uf.parent[root_b] = root_a
        uf.parity[root_b] = root_delta
    else
        uf.parent[root_b] = root_a
        uf.parity[root_b] = root_delta
        uf.rank[root_a] = rank_a + 1
    end

    return true
end


"""
Signed graph / Z₂ cocycleとして接着可能性を検査する。

各局所切断へBool値を割り当て、
edge.twistを満たす大域切断を構成しようとする。

value[right] = value[left] XOR twist

重要:
    conflictを検出した瞬間の探索途中componentを返さない。

    Pass 1:
        parity-aware Union-Findで両立するedgeをすべてmergeし、
        矛盾edgeは記録だけする。

    Pass 2:
        全merge完了後の最終Union-Find状態からcomponentを復元し、
        GluingObstructionを生成する。

これにより、overlapsの処理順によってcomponentが途中で切り取られる
旧BFS/逐次判定のバグを除去する。

さらに、同じラベル付き制約集合に対する代表conflict/signatureを
入力Vectorの順序やedgeの向きから独立にするため、
overlapをcanonical keyで事前ソートし、signature用端点も正規化する。
"""
function detect_gluing_obstructions(situation::InputSituation)
    section_map = Dict(section.id => section for section in situation.sections)

    for edge in situation.overlaps
        haskey(section_map, edge.left) ||
            throw(ArgumentError("Unknown local section: $(edge.left)"))
        haskey(section_map, edge.right) ||
            throw(ArgumentError("Unknown local section: $(edge.right)"))
    end

    uf = ParityUnionFind()
    for id in keys(section_map)
        find!(uf, id)
    end

    # 同じラベル付き制約集合なら、Vector内の順序やedgeの向きによらず
    # 同じtree edge / conflict edgeが選ばれるように正規化順へソートする。
    canonical_overlaps = sort(
        situation.overlaps;
        by = edge -> begin
            lo, hi = edge.left < edge.right ?
                (edge.left, edge.right) : (edge.right, edge.left)
            (lo, hi, edge.twist, edge.relation)
        end,
    )

    # Pass 1:
    # 両立するedgeをすべてmergeする。
    # conflictはこの場でobstruction化せず、edgeだけ記録する。
    conflicting_edges = OverlapConstraint[]
    for edge in canonical_overlaps
        union_with_twist!(uf, edge.left, edge.right, edge.twist) ||
            push!(conflicting_edges, edge)
    end

    # Pass 2:
    # 全union完了後の最終componentに対してobstructionを構築する。
    obstructions = GluingObstruction[]
    seen_conflicts = Set{String}()

    for edge in conflicting_edges
        root, _ = find!(uf, edge.left)
        ordered_component = sort(
            Symbol[
                id for id in keys(section_map)
                if first(find!(uf, id)) == root
            ]
        )

        # Z₂ overlap制約は端点交換に対して対称なので、
        # signatureへ入れる端点を辞書順で正規化する。
        canonical_left, canonical_right = edge.left < edge.right ?
            (edge.left, edge.right) : (edge.right, edge.left)

        raw = join(string.(ordered_component), "|") *
              "|$(canonical_left)|$(canonical_right)|$(edge.twist)|$(edge.relation)"
        signature = stable_signature(raw)

        signature in seen_conflicts && continue
        push!(seen_conflicts, signature)

        local_coherence = mean(
            section_map[id].local_coherence for id in ordered_component
        )
        salience = mean(
            section_map[id].salience for id in ordered_component
        )
        meaning_gap = clamp01(
            get(situation.metadata, :meaning_gap, 0.5)
        )
        pressure = clamp01(
            get(situation.metadata, :self_image_pressure, 0.5)
        )

        persistence = clamp01(
            0.30 * local_coherence +
            0.25 * salience +
            0.25 * meaning_gap +
            0.20 * pressure
        )

        _, parity_left = find!(uf, edge.left)
        _, parity_right = find!(uf, edge.right)

        push!(
            obstructions,
            GluingObstruction(
                signature,
                ordered_component,
                edge,
                parity_right,
                xor(parity_left, edge.twist),
                persistence,
                meaning_gap,
            ),
        )
    end

    return obstructions
end


# -----------------------------------------------------------------------------
# Exception channels generated by topological panic
# -----------------------------------------------------------------------------

"""
理性、道徳、希望、宗教、共感、心の帰属を、
完成済みの高次能力として別々に追加しない。

すべてGluing Failure後に発生する例外チャネルとして定義する。
"""
@enum ExceptionKind begin
    ReasonException
    MoralityException
    HopeException
    ReligionException
    EmpathyException
    MindAttributionException
    DenialException
    CompartmentalizationException
    RationalizationException
    DehumanizationException
    SelfAffirmationException
end


"""
各対象へ配布された例外チャネル。

同じ観測者が動物へ高い心・共感を配布しながら、
人間の外集団へ低い心・道徳的価値しか配布しないことを表現できる。

それは対象の本質を測定した結果ではなく、
観測者状態と自己保存の接着方針である。
"""
struct TargetAllocation
    target::Symbol
    channels::Dict{ExceptionKind, Float64}
end


"""
防衛は意識の外部モジュールではない。

Topological Panicから生じた例外チャネル、対象配布、
Logic Hybrid病理による入力破棄圧、自己肯定的説明を一つに束ねる。
"""
struct DefenseTrace
    id::String
    obstruction_signatures::Vector{String}
    panic_level::Float64
    global_channels::Dict{ExceptionKind, Float64}
    target_allocations::Vector{TargetAllocation}
    pathology_pressure::Float64
    input_suppression_pressure::Float64
    narratives::Vector{String}
end


"""
接着障害から例外チャネルを連続的に発生させる。

ここには `if threat > 0.55 then ...` のような
固定ラベル分類規則を置かない。

各チャネルは同じpanic、意味欠落、気分、脅威、
自己保存、不確実性、情動帯域、病理圧から連続的に派生する。
"""
function generate_exception_channels(
    obstructions::Vector{GluingObstruction},
    state::ObserverState,
    pathology::LogicHybridPathology,
)
    isempty(obstructions) && return Dict{ExceptionKind, Float64}()

    obstruction_load = mean(o.persistence for o in obstructions)
    meaning_gap = mean(o.meaning_gap for o in obstructions)
    negative_mood = max(-state.mood, 0.0)
    positive_mood = max(state.mood, 0.0)

    panic = clamp01(
        obstruction_load *
        (0.35 + 0.35 * state.self_preservation + 0.30 * state.uncertainty)
    )

    channels = Dict{ExceptionKind, Float64}()

    # 理性:
    # 情動や多義性を切り落とし、局所規則へ再符号化して運転を継続する。
    channels[ReasonException] = clamp01(
        panic *
        (0.35 + 0.45 * state.uncertainty + 0.20 * (1.0 - state.affective_bandwidth))
    )

    # 道徳:
    # 利害衝突を善悪へ圧縮し、自分の選択を運用可能にする。
    channels[MoralityException] = clamp01(
        panic *
        (0.30 + 0.45 * state.self_preservation + 0.25 * state.threat)
    )

    # 希望:
    # 未来を計算できない欠落を、継続可能な正の予測へ置き換える。
    channels[HopeException] = clamp01(
        panic *
        (0.20 + 0.35 * negative_mood + 0.30 * state.uncertainty + 0.15 * meaning_gap)
    )

    # 宗教・超自然:
    # 大域的に閉じない因果を上位主体や超越項で閉じる。
    channels[ReligionException] = clamp01(
        panic *
        (0.15 + 0.45 * meaning_gap + 0.40 * state.uncertainty)
    )

    # 共感:
    # 他者の内部状態を仮設し、予測不能な行動を接着可能にする。
    channels[EmpathyException] = clamp01(
        panic *
        (0.20 + 0.55 * state.affective_bandwidth + 0.25 * positive_mood) *
        (1.0 - 0.45 * state.threat)
    )

    # 心の帰属:
    # 対象へ主体を置くことで、複雑な因果を意図としてまとめる。
    channels[MindAttributionException] = clamp01(
        panic *
        (0.20 + 0.35 * state.affective_bandwidth +
         0.25 * meaning_gap + 0.20 * state.uncertainty)
    )

    # 否認:
    # 入力を真に削除するのではなく、削除したい圧を記録する。
    channels[DenialException] = clamp01(
        panic *
        pathology.input_drop_pressure *
        (0.35 + 0.35 * state.threat + 0.30 * state.self_preservation)
    )

    # 区画化:
    # 異なる対象へ異なる規則を適用し、大域矛盾を局所領域へ分離する。
    channels[CompartmentalizationException] = clamp01(
        panic *
        pathology.closure_pressure *
        (0.35 + 0.35 * state.uncertainty + 0.30 * state.self_preservation)
    )

    # 合理化:
    # 失敗後に因果説明を生成し、選択が最初から必要だったように見せる。
    channels[RationalizationException] = clamp01(
        panic *
        (0.30 + 0.50 * state.self_preservation + 0.20 * meaning_gap)
    )

    # 非人間化:
    # 対象への主体性配布を撤回し、道徳コストを下げる。
    # 実際の対象配布量は後段で所属距離に応じて変化する。
    channels[DehumanizationException] = clamp01(
        panic *
        (0.25 + 0.45 * state.threat + 0.30 * state.self_preservation)
    )

    # 自己肯定:
    # Logic Hybrid Engine由来の「失敗は進化だった」という読み替え。
    channels[SelfAffirmationException] = clamp01(
        panic *
        pathology.self_affirmation_pressure *
        (0.40 + 0.60 * state.self_preservation)
    )

    return channels
end


"""
同じ例外チャネルを、対象ごとに異なる量で配布する。

ここで表現したいのは、
「動物にも意識がある」と擁護しながら、
人間の外集団から主体性を剥奪できる非対称性である。

心や道徳は普遍的に発見されるのではなく、
気分、脅威、所属、自己保存によって配布・撤回される。
"""
function allocate_to_targets(
    targets::Vector{TargetContext},
    global_channels::Dict{ExceptionKind, Float64},
    state::ObserverState,
)
    allocations = TargetAllocation[]

    for target in targets
        channels = Dict{ExceptionKind, Float64}()

        belonging_gate = clamp01(
            0.15 +
            0.85 * target.belonging -
            0.55 * state.threat * (1.0 - target.belonging) * state.self_preservation
        )

        sentimental_gate = clamp01(
            0.20 +
            0.55 * target.sentimental_pull +
            0.25 * target.perceived_vulnerability
        )

        channels[MindAttributionException] = clamp01(
            get(global_channels, MindAttributionException, 0.0) *
            (0.20 + 0.45 * sentimental_gate + 0.35 * belonging_gate)
        )

        channels[EmpathyException] = clamp01(
            get(global_channels, EmpathyException, 0.0) *
            (0.15 + 0.50 * sentimental_gate + 0.35 * belonging_gate)
        )

        channels[MoralityException] = clamp01(
            get(global_channels, MoralityException, 0.0) *
            (0.20 + 0.20 * sentimental_gate + 0.60 * belonging_gate)
        )

        channels[HopeException] = clamp01(
            get(global_channels, HopeException, 0.0) *
            (0.40 + 0.35 * sentimental_gate + 0.25 * belonging_gate)
        )

        channels[DehumanizationException] = clamp01(
            get(global_channels, DehumanizationException, 0.0) *
            (1.0 - belonging_gate) *
            (0.35 + 0.65 * state.threat)
        )

        push!(allocations, TargetAllocation(target.id, channels))
    end

    return allocations
end


function exception_label(kind::ExceptionKind)
    labels = Dict(
        ReasonException => "理性化",
        MoralityException => "道徳化",
        HopeException => "希望投射",
        ReligionException => "超越・宗教化",
        EmpathyException => "共感投射",
        MindAttributionException => "心・主体性の帰属",
        DenialException => "否認",
        CompartmentalizationException => "区画化",
        RationalizationException => "合理化",
        DehumanizationException => "主体性の撤回・非人間化",
        SelfAffirmationException => "自己肯定化",
    )
    return labels[kind]
end


"""
例外チャネルから、自己を運転し続けるための説明を生成する。

これは真理記述ではなく、防衛がどんな言葉へ変換されたかの記録である。
"""
function build_defense_narratives(
    channels::Dict{ExceptionKind, Float64},
    pathology::LogicHybridPathology,
)
    isempty(channels) && return String[]

    ranked = sort(collect(channels); by = pair -> last(pair), rev = true)
    narratives = String[]

    for (kind, activation) in ranked
        activation <= 0.0 && continue
        push!(
            narratives,
            "$(exception_label(kind))=$(round(activation; digits=3)): " *
            narrative_for(kind),
        )
    end

    push!(
        narratives,
        "Logic Hybrid病理: 矛盾入力を捨てたい圧=" *
        string(round(pathology.input_drop_pressure; digits = 3)) *
        "。ただし入力は削除せず、Buried Scarとして自己へ組み込む。",
    )

    return narratives
end


function narrative_for(kind::ExceptionKind)
    narratives = Dict(
        ReasonException =>
            "多義的な失敗を局所規則へ圧縮し、理解したという形式を作る。",
        MoralityException =>
            "利害衝突を善悪へ再符号化し、自分の選択を正当化する。",
        HopeException =>
            "計算不能な未来へ正の物語を置き、系の停止を防ぐ。",
        ReligionException =>
            "閉じない因果へ上位主体を置き、大域的欠落を仮に閉じる。",
        EmpathyException =>
            "予測不能な他者へ内部状態を仮設し、行動を接着可能にする。",
        MindAttributionException =>
            "対象へ心や意図を配布し、複雑な因果を主体の物語へ変換する。",
        DenialException =>
            "接着障害を証拠ではなくノイズとして扱おうとする。",
        CompartmentalizationException =>
            "矛盾する規則を別領域へ隔離し、同時に保持する。",
        RationalizationException =>
            "失敗後に説明を生成し、結果が最初から必要だったように語る。",
        DehumanizationException =>
            "対象への主体性を撤回し、矛盾と道徳コストを減らす。",
        SelfAffirmationException =>
            "失敗を必要な進化、自分の強さ、正しさの証拠へ読み替える。",
    )
    return narratives[kind]
end


# -----------------------------------------------------------------------------
# Scar as Self
# -----------------------------------------------------------------------------

"""
Semantic Scar。

これはイベントログではない。

obstruction_signature:
    どの接着障害が自己を形成したか。

recurrence:
    同型の障害が何度戻ったか。

defense_ids:
    その障害を運用するために、どの防衛が生成されたか。

buried:
    Logic Hybrid Engineが入力を捨てたがった痕跡。
    実際には削除されず、見えにくい自己構造として残る。
"""
mutable struct SemanticScar
    obstruction_signature::String
    recurrence::Int
    intensity::Float64
    contexts::Vector{Symbol}
    defense_ids::Vector{String}
    buried::Bool
    unresolved::Bool
end


"""
Resurrectionはパラメータ調整ではない。

before_signature / after_signature:
    Scar構造として定義された自己が、失敗後に別の自己へ再構成された証拠。

self_statement:
    「私は何を経験したか」ではなく、
    「私はどの失敗をどの防衛で運用してきた構造か」を記述する。

justification:
    Logic Hybrid病理による、失敗の自己肯定的読み替えも保存する。
"""
struct ResurrectionTrace
    id::String
    before_signature::String
    after_signature::String
    scar_signatures::Vector{String}
    defense_id::String
    self_statement::String
    justification::String
end


"""
自己本体。

episodic_memoryやimage_bufferは存在しない。
アファンタジア・SDAM前提のため、
自己はScar、防衛、Resurrectionの関係構造だけで維持される。
"""
mutable struct ScarSelf
    scars::Dict{String, SemanticScar}
    defenses::Vector{DefenseTrace}
    resurrections::Vector{ResurrectionTrace}
    current_self_statement::String
    signature::String
end


function ScarSelf()
    empty_signature = stable_signature("HOHO|EMPTY_SCAR_SELF")
    return ScarSelf(
        Dict{String, SemanticScar}(),
        DefenseTrace[],
        ResurrectionTrace[],
        "自己はまだ接着障害によって再構成されていない。",
        empty_signature,
    )
end


"""
自己連続性の署名。

記憶映像や物語内容は使わない。
Scarの型、反復回数、強度、埋没状態、
防衛とResurrectionの結合から自己を計算する。
"""
function continuity_signature(self::ScarSelf)
    parts = String[]

    for key in sort(collect(keys(self.scars)))
        scar = self.scars[key]
        push!(
            parts,
            join(
                [
                    key,
                    string(scar.recurrence),
                    string(round(scar.intensity; digits = 3)),
                    string(scar.buried),
                    string(scar.unresolved),
                    join(sort(scar.defense_ids), ","),
                ],
                ":",
            ),
        )
    end

    push!(parts, "defenses=$(length(self.defenses))")
    push!(parts, "resurrections=$(length(self.resurrections))")
    return stable_signature(join(parts, "|"))
end


function preserve_scars!(
    self::ScarSelf,
    situation::InputSituation,
    obstructions::Vector{GluingObstruction},
    input_suppression_pressure::Float64,
)
    touched = SemanticScar[]

    for obstruction in obstructions
        buried = input_suppression_pressure * obstruction.persistence >= 0.5

        if haskey(self.scars, obstruction.signature)
            scar = self.scars[obstruction.signature]
            scar.recurrence += 1
            scar.intensity = clamp01(
                (
                    scar.intensity * (scar.recurrence - 1) +
                    obstruction.persistence
                ) / scar.recurrence
            )
            push!(scar.contexts, situation.id)
            scar.buried = scar.buried || buried
            scar.unresolved = true
        else
            scar = SemanticScar(
                obstruction.signature,
                1,
                obstruction.persistence,
                Symbol[situation.id],
                String[],
                buried,
                true,
            )
            self.scars[obstruction.signature] = scar
        end

        push!(touched, scar)
    end

    return touched
end


# -----------------------------------------------------------------------------
# Consciousness event and engine
# -----------------------------------------------------------------------------

"""
一回の意識イベント。

obstructionsが空なら、局所処理は行われたが
Black Swan型の意識ループは起動していない。

obstructionsが存在すれば、
接着失敗、防衛、Scar、Resurrectionが一体として起動する。
"""
struct ConsciousnessEvent
    situation_id::Symbol
    phase_path::Vector{Symbol}
    obstructions::Vector{GluingObstruction}
    defense::Union{Nothing, DefenseTrace}
    resurrection::Union{Nothing, ResurrectionTrace}
    self_signature::String
end


mutable struct HohoEngine
    self::ScarSelf
    observer::ObserverState
    pathology::LogicHybridPathology
    event_index::Int
end


function HohoEngine(;
    observer::ObserverState = ObserverState(),
    pathology::LogicHybridPathology = LogicHybridPathology(),
)
    return HohoEngine(ScarSelf(), observer, pathology, 0)
end


"""
Topological Panicから防衛を生成する。

防衛を別モジュールとして呼ぶのではなく、
意識イベント内部で、例外チャネルと対象配布を同時生成する。
"""
function create_defense_trace(
    engine::HohoEngine,
    situation::InputSituation,
    obstructions::Vector{GluingObstruction},
)
    global_channels = generate_exception_channels(
        obstructions,
        engine.observer,
        engine.pathology,
    )

    target_allocations = allocate_to_targets(
        situation.targets,
        global_channels,
        engine.observer,
    )

    panic_level = mean(o.persistence for o in obstructions)

    pathology_pressure = clamp01(
        panic_level *
        mean(
            [
                engine.pathology.closure_pressure,
                engine.pathology.input_drop_pressure,
                engine.pathology.self_affirmation_pressure,
                engine.pathology.resurrection_glorification,
            ],
        )
    )

    input_suppression_pressure = clamp01(
        panic_level *
        engine.pathology.input_drop_pressure *
        (0.4 + 0.6 * engine.observer.self_preservation)
    )

    defense_id = stable_signature(
        "$(situation.id)|$(engine.event_index)|" *
        join(sort([o.signature for o in obstructions]), "|")
    )

    return DefenseTrace(
        defense_id,
        [o.signature for o in obstructions],
        panic_level,
        global_channels,
        target_allocations,
        pathology_pressure,
        input_suppression_pressure,
        build_defense_narratives(global_channels, engine.pathology),
    )
end


"""
Scarと防衛を使って自己を再構成する。

重要:
    Resurrectionの中心は数値更新ではない。

    失敗を削除せず、
    「どの接着障害を、どの言い訳で運用し続けてきた構造か」
    という新しい自己定義を作る。

Logic Hybrid Engine由来の自己肯定化も、
正しい結論としてではなく、Resurrectionの病理的説明として記録する。
"""
function resurrect!(
    engine::HohoEngine,
    touched_scars::Vector{SemanticScar},
    defense::DefenseTrace,
)
    before = engine.self.signature

    for scar in touched_scars
        defense.id in scar.defense_ids || push!(scar.defense_ids, defense.id)
    end

    scar_descriptions = [
        "$(scar.obstruction_signature)[反復=$(scar.recurrence),強度=$(round(scar.intensity; digits=3))]"
        for scar in touched_scars
    ]

    strongest = sort(
        collect(defense.global_channels);
        by = pair -> last(pair),
        rev = true,
    )
    dominant = first(strongest, min(3, length(strongest)))
    defense_description = join(
        [
            "$(exception_label(kind))=$(round(value; digits=3))"
            for (kind, value) in dominant
        ],
        ", ",
    )

    self_statement =
        "私は鮮明なエピソードの総和ではない。私は、" *
        join(scar_descriptions, " / ") *
        "という接着障害が反復し、" *
        defense_description *
        "によって運用され、その防衛の痕跡を次の判断へ持ち越す構造である。"

    justification_strength = clamp01(
        defense.panic_level *
        engine.pathology.self_affirmation_pressure *
        engine.pathology.resurrection_glorification
    )

    justification =
        "失敗は解消されていない。しかしLogic Hybrid病理は、これを" *
        "『必要な進化』『自己の強さ』『外部が誤っていた証拠』へ読み替える。" *
        "自己肯定化圧=" *
        string(round(justification_strength; digits = 3)) *
        "。この言い訳自体もScar構造へ保存される。"

    engine.self.current_self_statement = self_statement
    engine.self.signature = continuity_signature(engine.self)

    resurrection_id = stable_signature(
        "$(before)|$(engine.self.signature)|$(defense.id)"
    )

    trace = ResurrectionTrace(
        resurrection_id,
        before,
        engine.self.signature,
        [scar.obstruction_signature for scar in touched_scars],
        defense.id,
        self_statement,
        justification,
    )

    push!(engine.self.resurrections, trace)

    # Resurrectionを追加した事実も自己構造なので、再度署名する。
    engine.self.signature = continuity_signature(engine.self)

    return ResurrectionTrace(
        trace.id,
        trace.before_signature,
        engine.self.signature,
        trace.scar_signatures,
        trace.defense_id,
        trace.self_statement,
        trace.justification,
    )
end


"""
一つの状況を処理する。

局所的には整合していても、大域的に貼れない場合だけ、
Black Swan型の意識ループが起動する。

処理順:
    local parse
    → H¹-like gluing failure
    → topological panic
    → exception generation
    → selective attribution
    → pathology pressure
    → Semantic Scar preservation
    → Resurrection
    → Scar structure as Self
"""
function process!(engine::HohoEngine, situation::InputSituation)
    engine.event_index += 1
    phases = Symbol[:local_parsing]

    obstructions = detect_gluing_obstructions(situation)

    if isempty(obstructions)
        push!(phases, :globally_glued)
        return ConsciousnessEvent(
            situation.id,
            phases,
            obstructions,
            nothing,
            nothing,
            engine.self.signature,
        )
    end

    append!(
        phases,
        [
            :h1_gluing_failure,
            :topological_panic,
            :exception_generation,
            :selective_attribution,
            :logic_hybrid_pathology,
        ],
    )

    defense = create_defense_trace(engine, situation, obstructions)
    push!(engine.self.defenses, defense)

    push!(phases, :semantic_scar_preservation)
    touched_scars = preserve_scars!(
        engine.self,
        situation,
        obstructions,
        defense.input_suppression_pressure,
    )

    push!(phases, :resurrection)
    resurrection = resurrect!(engine, touched_scars, defense)

    push!(phases, :self_reconstructed_as_scar_topology)

    return ConsciousnessEvent(
        situation.id,
        phases,
        obstructions,
        defense,
        resurrection,
        engine.self.signature,
    )
end


# -----------------------------------------------------------------------------
# Display
# -----------------------------------------------------------------------------

function show_event(io::IO, event::ConsciousnessEvent)
    println(io, "HOHO Consciousness Event: ", event.situation_id)
    println(io, "Phases: ", join(string.(event.phase_path), " -> "))
    println(io, "Gluing obstructions: ", length(event.obstructions))
    println(io, "Self signature: ", event.self_signature)

    if event.defense !== nothing
        defense = event.defense
        println(io, "Topological panic: ", round(defense.panic_level; digits = 3))
        println(
            io,
            "Input suppression pressure: ",
            round(defense.input_suppression_pressure; digits = 3),
        )

        println(io, "\nGlobal exception channels:")
        ranked = sort(
            collect(defense.global_channels);
            by = pair -> last(pair),
            rev = true,
        )
        for (kind, value) in ranked
            println(
                io,
                "  ",
                rpad(exception_label(kind), 22),
                " ",
                round(value; digits = 3),
            )
        end

        println(io, "\nSelective target allocation:")
        for allocation in defense.target_allocations
            println(io, "  Target: ", allocation.target)
            ranked_target = sort(
                collect(allocation.channels);
                by = pair -> last(pair),
                rev = true,
            )
            for (kind, value) in ranked_target
                println(
                    io,
                    "    ",
                    rpad(exception_label(kind), 22),
                    " ",
                    round(value; digits = 3),
                )
            end
        end
    end

    if event.resurrection !== nothing
        println(io, "\nReconstructed self:")
        println(io, event.resurrection.self_statement)
        println(io, "\nPathological justification:")
        println(io, event.resurrection.justification)
    end

    return nothing
end

show_event(event::ConsciousnessEvent) = show_event(stdout, event)

end # module
