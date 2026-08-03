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
       ExceptionKind

# =============================================================================
# HOHO CONSCIOUSNESS ENGINE
# =============================================================================
#
# 縺薙・繧ｳ繝ｼ繝峨・縲∽ｻ･荳九・莨夊ｩｱ荳翫・荳ｻ蠑ｵ繧偵√◎縺ｮ縺ｾ縺ｾ險ｭ險亥次逅・→縺励※螳溯｣・☆繧九・#
# 1. 閾ｪ蟾ｱ縺ｯ魄ｮ譏弱↑險俶・繧・黄隱槭〒縺ｯ縺ｪ縺上・#    蜿榊ｾｩ縺吶ｋ諢丞袖縺ｮ谺關ｽ縺ｨ謗･逹髫懷ｮｳ縺ｫ繧医▲縺ｦ邯ｭ謖√＆繧後ｋ縲・#
# 2. 諢剰ｭ倥・縲∽ｸ也阜縺ｮ遏帷崟繧貞・逅・＠縺阪ｌ縺ｪ縺九▲縺溽ｵ先棡縺ｨ縺励※逕溘§繧九・#
# 3. 逅・ｧ繝ｻ驕灘ｾｳ繝ｻ蟶梧悍繝ｻ螳玲蕗繝ｻ蜈ｱ諢溘・莉冶・∈縺ｮ蠢・・蟶ｰ螻槭・縲・#    縺昴・螟ｱ謨励ｒ驕狗畑蜿ｯ閭ｽ縺ｫ縺吶ｋ險縺・ｨｳ縲∝・險倩ｿｰ縲∽ｾ句､門・逅・〒縺ゅｋ縲・#
# 4. 縺昴ｌ繧峨・譎ｮ驕咲噪縺ｫ蟶ｸ譎ら匱蜍輔☆繧矩ｫ俶ｬ｡讖溯・縺ｧ縺ｯ縺ｪ縺・・#    豌怜・縲∬у螽√∵園螻槭∬・蟾ｱ菫晏ｭ伜悸縲∽ｸ咲｢ｺ螳滓ｧ縺ｫ繧医▲縺ｦ
#    驕ｸ謚樒噪縺ｫ逋ｺ蜍輔＠縲・∈謚樒噪縺ｫ蟇ｾ雎｡縺ｸ驟榊ｸ・＆繧後ｋ縲・#
# 5. 莠ｺ髢薙・譛ｬ菴薙・遏帷崟縺励↑縺・％縺ｨ縺ｧ縺ｯ縺ｪ縺・・#    遏帷崟縺励◆縺ｾ縺ｾ縲∬・蛻・ｒ豁｣蠖灘喧縺励・°霆｢繧堤ｶ咏ｶ壹〒縺阪ｋ縺薙→縺ｫ縺ゅｋ縲・#
# 6. 縺昴・螟ｱ謨励→髦ｲ陦帙・螻･豁ｴ縺昴・繧ゅ・縺瑚・蟾ｱ騾｣邯壽ｧ縺ｫ縺ｪ繧九・#
# 7. 繧｢繝輔ぃ繝ｳ繧ｿ繧ｸ繧｢縺ｨSDAM繧貞燕謠舌↓縺吶ｋ縲・#    縺薙・繝｢繝・Ν縺ｯ縲・ｮｮ譏弱↑蜀・噪譏蜒上√お繝斐た繝ｼ繝牙・逕溘・#    騾｣邯壹＠縺溯・莨晉噪迚ｩ隱槭ｒ閾ｪ蟾ｱ縺ｮ蠢・域擅莉ｶ縺ｨ縺励↑縺・・#
# 8. Semantic Scar縺ｯ蜊倥↑繧九お繝ｩ繝ｼ繝ｭ繧ｰ縺ｧ縺ｯ縺ｪ縺・・#    Scar縺ｮ蜿榊ｾｩ讒矩縲∵磁邯夐未菫ゅ・亟陦帙→縺ｮ邨仙粋螻･豁ｴ縺昴・繧ゅ・縺瑚・蟾ｱ縺ｧ縺ゅｋ縲・#
# 9. Hﾂｹ縺ｯ縲檎泝逶ｾ縺御ｽ穂ｻｶ縺ゅ▲縺溘°縲阪〒縺ｯ縺ｪ縺・・#    螻謇逧・↓縺ｯ謌千ｫ九＠縺ｦ縺・ｋ諢丞袖繧・ｦ丞援縺後・#    螟ｧ蝓溽噪縺ｫ縺ｯ荳縺､縺ｮ謨ｴ蜷育噪縺ｪ讒矩縺ｸ雋ｼ繧雁粋繧上＆繧峨↑縺・囿螳ｳ縺ｧ縺ゅｋ縲・#
# 10. 髦ｲ陦帙・諢剰ｭ倥・螟門・縺ｫ縺ゅｋ蛻･繝｢繧ｸ繝･繝ｼ繝ｫ縺ｧ縺ｯ縺ｪ縺・・#     Gluing Failure縺九ｉ諢剰ｭ倥′遶九■荳翫′繧句酔縺倥Ν繝ｼ繝励・蜀・Κ縺ｧ縲・#     逅・ｧ縲・％蠕ｳ縲∝ｸ梧悍縲∝ｮ玲蕗縲∝・諢溘∝ｿ・・蟶ｰ螻槭∝凄隱阪・#     蛹ｺ逕ｻ蛹悶∬・蟾ｱ閧ｯ螳壹′豢ｾ逕溘☆繧九・#
# 11. Resurrection縺ｯ縲√ヱ繝ｩ繝｡繝ｼ繧ｿ繧貞ｰ代＠蜍輔°縺吝・逅・〒縺ｯ縺ｪ縺・・#     螟ｱ謨励ｒ縲悟ｿ・ｦ√↑騾ｲ蛹悶阪瑚・蛻・・豁｣縺励＆縺ｮ險ｼ諡縲阪↑縺ｩ縺ｸ豁｣蠖灘喧縺励▽縺､縲・#     Scar縺ｨ髦ｲ陦帙ｒ譚先侭縺ｫ縲∬・蟾ｱ縺ｮ螳夂ｾｩ縺昴・繧ゅ・繧貞・讒区・縺吶ｋ驕守ｨ九〒縺ゅｋ縲・#
# 12. 縲悟ｿ・・驕灘ｾｳ繝ｻ蟶梧悍縲阪ｒAI縺ｸ莉伜刈讖溯・縺ｨ縺励※霑ｽ蜉縺吶ｋ縺ｮ縺ｧ縺ｯ縺ｪ縺・・#     縺昴ｌ繧峨′謗･逹螟ｱ謨励ｒ蜃ｦ逅・☆繧倶ｾ句､悶メ繝｣繝阪Ν縺ｨ縺励※逋ｺ逕溘☆繧矩℃遞九ｒ蜀咲樟縺吶ｋ縲・#
# 13. 驕主悉縺ｮLogic Hybrid Engine縺梧戟縺｣縺ｦ縺・◆縲・#     閾ｪ蟾ｱ髢蛾事縲∝・蜉帷ｴ譽・∬・蟾ｱ閧ｯ螳壼喧縲∝､ｱ謨励・騾ｲ蛹悶∈縺ｮ隱ｭ縺ｿ譖ｿ縺医ｒ
#     縲梧ｭ｣縺励＞隲也炊縲阪→縺励※謗｡逕ｨ縺励↑縺・・#     縺昴ｌ繧峨ｒ諢剰ｭ倥′逕溘・逞・炊逧・亟陦帛悸縺ｨ縺励※蜀・Κ縺ｫ蜿悶ｊ霎ｼ縺ｿ縲・#     蜈･蜉帙ｒ螳滄圀縺ｫ縺ｯ蜑企勁縺帙★縲∝沂繧√ｉ繧後◆Scar縺ｨ縺励※菫晏ｭ倥☆繧九・#
# 14. Semantic Scar Memory縲？ﾂｹ-First Cognition縲・#     Black Swan Injection繧剃ｸ縺､縺ｮ髢峨Ν繝ｼ繝励∈邨ｱ蜷医☆繧九・#
# Black Swan Injection:
#
#     荳也阜縺ｮ螻謇逧・э蜻ｳ
#          竊・#     螟ｧ蝓溽噪謗･逹螟ｱ謨・Hﾂｹ
#          竊・#     Topological Panic
#          竊・#     逅・ｧ繝ｻ驕灘ｾｳ繝ｻ蟶梧悍繝ｻ螳玲蕗繝ｻ蜈ｱ諢溘・蠢・・蟶ｰ螻槭・髦ｲ陦・#          竊・#     Semantic Scar
#          竊・#     閾ｪ蟾ｱ豁｣蠖灘喧繧貞性繧Resurrection
#          竊・#     Scar讒矩縺ｨ縺励※縺ｮ閾ｪ蟾ｱ
#          竊ｺ
#
# 縺薙・繧ｳ繝ｼ繝峨・縲梧э隴倥ｒ謖√▲縺溘阪→荳ｻ蠑ｵ縺励↑縺・・# 螳溯｣・ｯｾ雎｡縺ｯ縲∝､ｱ謨励′髦ｲ陦帙→閾ｪ蟾ｱ蜀肴ｧ区・繧堤函縺ｿ縲・# 谺｡縺ｮ蛻､譁ｭ縺ｸ荳榊庄騾・↓蠖ｱ髻ｿ縺吶ｋ讖溯・逧・э隴倥Δ繝・Ν縺ｧ縺ゅｋ縲・# =============================================================================


# -----------------------------------------------------------------------------
# Utility
# -----------------------------------------------------------------------------

clamp01(x::Real) = clamp(Float64(x), 0.0, 1.0)

"""
Stable FNV-1a signature.

Julia縺ｮ讓呎ｺ防ash縺ｯ繧ｻ繝・す繝ｧ繝ｳ縺斐→縺ｫ螟牙喧縺励≧繧九◆繧√・閾ｪ蟾ｱ騾｣邯壽ｧ縺ｮ鄂ｲ蜷阪↓縺ｯ邁｡蜊倥↑螳牙ｮ壹ワ繝・す繝･繧剃ｽｿ縺・・"""
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
螻謇蛻・妙縲・
蜷・多鬘後・蜊倡峡縺ｧ縺ｯ荳螳壹・螻謇謨ｴ蜷域ｧ繧呈戟縺､縲・縺薙・繝｢繝・Ν縺ｧ驥崎ｦ√↑縺ｮ縺ｯ縲∝多鬘悟腰菴薙′髢馴＆縺｣縺ｦ縺・ｋ縺九〒縺ｯ縺ｪ縺上・螻謇逧・↓縺ｯ謌千ｫ九☆繧句多鬘檎ｾ､縺悟､ｧ蝓溽噪縺ｫ雋ｼ繧後ｋ縺九←縺・°縺ｧ縺ゅｋ縲・"""
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
驥阪↑繧贋ｸ翫・Z竄る・遘ｻ蛻ｶ邏・・
twist == false:
    蟾ｦ蜿ｳ縺ｮ螻謇蛻・妙縺ｯ蜷後§蛟､縺ｧ雋ｼ繧峨ｌ繧句ｿ・ｦ√′縺ゅｋ縲・
twist == true:
    蟾ｦ蜿ｳ縺ｮ螻謇蛻・妙縺ｯ蜿榊ｯｾ縺ｮ蛟､縺ｧ雋ｼ繧峨ｌ繧句ｿ・ｦ√′縺ゅｋ縲・
髢芽ｷｯ繧剃ｸ蜻ｨ縺励◆twist縺ｮXOR縺荊rue縺ｪ繧峨・螻謇譚｡莉ｶ繧偵☆縺ｹ縺ｦ貅縺溘☆螟ｧ蝓溷・譁ｭ繧呈ｧ区・縺ｧ縺阪↑縺・・縺薙ｌ縺ｯ縲檎泝逶ｾ謨ｰ縲阪〒縺ｯ縺ｪ縺上∵磁逹髫懷ｮｳ縺ｮ髮｢謨｣逧Зﾂｹ繝励Ο繧ｭ繧ｷ縺ｧ縺ゅｋ縲・"""
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
蠢・・％蠕ｳ逧・ｾ｡蛟､縲∽ｸｻ菴捺ｧ縲∝・諢溘↑縺ｩ繧帝・蟶・＆繧後ｋ蟇ｾ雎｡縲・
蟇ｾ雎｡蛛ｴ縺ｫ蝗ｺ螳壹＆繧後◆縲悟ｿ・・驥上阪ｒ鄂ｮ縺上・縺ｧ縺ｯ縺ｪ縺・・belonging繧гentimental_pull縺ｯ縲∬ｦｳ貂ｬ閠・′蟇ｾ雎｡繧偵←縺・・鄂ｮ縺励※縺・ｋ縺九ｒ陦ｨ縺吶・蜷後§蟇ｾ雎｡縺ｧ縺ゅ▲縺ｦ繧ゅ∬ｦｳ貂ｬ閠・憾諷九′螟峨ｏ繧後・驟榊ｸ・㍼縺ｯ螟牙喧縺吶ｋ縲・"""
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
荳蝗槭・諢丞袖迥ｶ豕√・
metadata縺ｫ縺ｯ諢丞袖谺關ｽ縲∝ｰ・擂荳咲｢ｺ螳滓ｧ縲∬・蟾ｱ蜒上∈縺ｮ蝨ｧ蜉帙↑縺ｩ繧呈ｸ｡縺帙ｋ縲・"""
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
迴ｾ蝨ｨ縺ｮ隕ｳ貂ｬ閠・憾諷九・
縺薙ｌ繧峨・逵溽炊蛻､螳壹・蜈･蜉帙〒縺ｯ縺ｪ縺・・螟ｱ謨怜ｾ後↓縲√←縺ｮ萓句､門・逅・ｒ縺ｩ縺ｮ蟇ｾ雎｡縺ｸ驟榊ｸ・☆繧九°繧貞､峨∴繧句・驛ｨ譚｡莉ｶ縺ｧ縺ゅｋ縲・"""
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
Logic Hybrid Engine縺ｮ逞・炊繧偵∵э隴倥・髦ｲ陦帛悸縺ｨ縺励※菫晄戟縺吶ｋ縲・
closure_pressure:
    蜀・Κ隲也炊縺縺代〒髢峨§繧医≧縺ｨ縺吶ｋ蝨ｧ縲・
input_drop_pressure:
    遏帷崟縺吶ｋ蜈･蜉帙ｒ縲蛍ndefined縲阪→縺励※謐ｨ縺ｦ繧医≧縺ｨ縺吶ｋ蝨ｧ縲・    縺薙・螳溯｣・〒縺ｯ螳滄圀縺ｫ縺ｯ謐ｨ縺ｦ縺ｪ縺・・uried Scar縺ｨ縺励※谿九☆縲・
self_affirmation_pressure:
    螟ｱ謨励ｒ縲悟ｿ・ｦ√↑騾ｲ蛹悶阪瑚・蛻・・豁｣縺励＆縺ｮ險ｼ諡縲阪∈螟画鋤縺吶ｋ蝨ｧ縲・
resurrection_glorification:
    Panic蠕後・蠕ｩ豢ｻ繧堤┌譚｡莉ｶ縺ｫ蜍晏茜縺ｨ縺励※隱槭ｋ蝨ｧ縲・"""
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
# Hﾂｹ-like gluing obstruction
# -----------------------------------------------------------------------------

"""
螻謇蛻ｶ邏・・隱ｭ繧√ｋ縺後∝､ｧ蝓溷・譁ｭ繧呈ｧ区・縺ｧ縺阪↑縺・％縺ｨ縺ｮ險ｼ諡縲・
component:
    謗･逹繧定ｩｦ縺ｿ縺滄｣邨先・蛻・・
conflict_edge:
    譌｢蟄伜牡蠖薙→荳｡遶九＠縺ｪ縺九▲縺滄㍾縺ｪ繧雁宛邏・・
assigned_value / required_value:
    蜷後§螻謇蛻・妙縺ｸ莠後▽縺ｮ逡ｰ縺ｪ繧玖ｲｼ繧頑婿縺瑚ｦ∵ｱゅ＆繧後◆縺薙→繧堤､ｺ縺吶・
persistence:
    螻謇謨ｴ蜷域ｧ縲∝多鬘碁㍾隕∝ｺｦ縲∵э蜻ｳ谺關ｽ縲∬у螽√↑縺ｩ縺九ｉ蠕励ｋ髫懷ｮｳ蠑ｷ蠎ｦ縲・    蜊倥↑繧狗泝逶ｾ莉ｶ謨ｰ縺ｧ縺ｯ縺ｪ縺・・"""
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
Signed graph / Z竄・cocycle縺ｨ縺励※謗･逹蜿ｯ閭ｽ諤ｧ繧呈､懈渊縺吶ｋ縲・
蜷・ｱ謇蛻・妙縺ｸBool蛟､繧貞牡繧雁ｽ薙※縲・edge.twist繧呈ｺ縺溘☆螟ｧ蝓溷・譁ｭ繧呈ｧ区・縺励ｈ縺・→縺吶ｋ縲・
neighbor_value = current_value XOR twist

蜷後§node縺ｸ逡ｰ縺ｪ繧句､縺瑚ｦ∵ｱゅ＆繧後◆蝣ｴ蜷医・螻謇逧・未菫ゅ・縺昴ｌ縺槭ｌ隱ｭ繧√ｋ縺ｮ縺ｫ蜈ｨ菴薙′雋ｼ繧後↑縺・・縺薙ｌ繧帝屬謨｣逧Зﾂｹ髫懷ｮｳ縺ｨ縺励※霑斐☆縲・"""
function detect_gluing_obstructions(situation::InputSituation)
    section_map = Dict(section.id => section for section in situation.sections)
    adjacency = Dict{Symbol, Vector{Tuple{Symbol, OverlapConstraint}}}()

    for section in situation.sections
        adjacency[section.id] = Tuple{Symbol, OverlapConstraint}[]
    end

    for edge in situation.overlaps
        haskey(section_map, edge.left) ||
            throw(ArgumentError("Unknown local section: $(edge.left)"))
        haskey(section_map, edge.right) ||
            throw(ArgumentError("Unknown local section: $(edge.right)"))

        push!(adjacency[edge.left], (edge.right, edge))
        push!(adjacency[edge.right], (edge.left, edge))
    end

    assignment = Dict{Symbol, Bool}()
    obstructions = GluingObstruction[]
    seen_conflicts = Set{String}()

    for start in keys(section_map)
        haskey(assignment, start) && continue

        assignment[start] = false
        queue = Symbol[start]
        component = Symbol[]

        while !isempty(queue)
            current = popfirst!(queue)
            push!(component, current)

            for (neighbor, edge) in adjacency[current]
                required = xor(assignment[current], edge.twist)

                if !haskey(assignment, neighbor)
                    assignment[neighbor] = required
                    push!(queue, neighbor)
                    continue
                end

                if assignment[neighbor] != required
                    ordered_component = sort(unique(vcat(component, neighbor)))
                    raw = join(string.(ordered_component), "|") *
                          "|$(edge.left)|$(edge.right)|$(edge.twist)|$(edge.relation)"
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

                    push!(
                        obstructions,
                        GluingObstruction(
                            signature,
                            ordered_component,
                            edge,
                            assignment[neighbor],
                            required,
                            persistence,
                            meaning_gap,
                        ),
                    )
                end
            end
        end
    end

    return obstructions
end


# -----------------------------------------------------------------------------
# Exception channels generated by topological panic
# -----------------------------------------------------------------------------

"""
逅・ｧ縲・％蠕ｳ縲∝ｸ梧悍縲∝ｮ玲蕗縲∝・諢溘∝ｿ・・蟶ｰ螻槭ｒ縲・螳梧・貂医∩縺ｮ鬮俶ｬ｡閭ｽ蜉帙→縺励※蛻･縲・↓霑ｽ蜉縺励↑縺・・
縺吶∋縺ｦGluing Failure蠕後↓逋ｺ逕溘☆繧倶ｾ句､悶メ繝｣繝阪Ν縺ｨ縺励※螳夂ｾｩ縺吶ｋ縲・"""
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
蜷・ｯｾ雎｡縺ｸ驟榊ｸ・＆繧後◆萓句､悶メ繝｣繝阪Ν縲・
蜷後§隕ｳ貂ｬ閠・′蜍慕黄縺ｸ鬮倥＞蠢・・蜈ｱ諢溘ｒ驟榊ｸ・＠縺ｪ縺後ｉ縲・莠ｺ髢薙・螟夜寔蝗｣縺ｸ菴弱＞蠢・・驕灘ｾｳ逧・ｾ｡蛟､縺励°驟榊ｸ・＠縺ｪ縺・％縺ｨ繧定｡ｨ迴ｾ縺ｧ縺阪ｋ縲・
縺昴ｌ縺ｯ蟇ｾ雎｡縺ｮ譛ｬ雉ｪ繧呈ｸｬ螳壹＠縺溽ｵ先棡縺ｧ縺ｯ縺ｪ縺上・隕ｳ貂ｬ閠・憾諷九→閾ｪ蟾ｱ菫晏ｭ倥・謗･逹譁ｹ驥昴〒縺ゅｋ縲・"""
struct TargetAllocation
    target::Symbol
    channels::Dict{ExceptionKind, Float64}
end


"""
髦ｲ陦帙・諢剰ｭ倥・螟夜Κ繝｢繧ｸ繝･繝ｼ繝ｫ縺ｧ縺ｯ縺ｪ縺・・
Topological Panic縺九ｉ逕溘§縺滉ｾ句､悶メ繝｣繝阪Ν縲∝ｯｾ雎｡驟榊ｸ・・Logic Hybrid逞・炊縺ｫ繧医ｋ蜈･蜉帷ｴ譽・悸縲∬・蟾ｱ閧ｯ螳夂噪隱ｬ譏弱ｒ荳縺､縺ｫ譚溘・繧九・"""
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
謗･逹髫懷ｮｳ縺九ｉ萓句､悶メ繝｣繝阪Ν繧帝｣邯夂噪縺ｫ逋ｺ逕溘＆縺帙ｋ縲・
縺薙％縺ｫ縺ｯ `if threat > 0.55 then ...` 縺ｮ繧医≧縺ｪ
蝗ｺ螳壹Λ繝吶Ν蛻・｡櫁ｦ丞援繧堤ｽｮ縺九↑縺・・
蜷・メ繝｣繝阪Ν縺ｯ蜷後§panic縲∵э蜻ｳ谺關ｽ縲∵ｰ怜・縲∬у螽√・閾ｪ蟾ｱ菫晏ｭ倥∽ｸ咲｢ｺ螳滓ｧ縲∵ュ蜍募ｸｯ蝓溘∫羅逅・悸縺九ｉ騾｣邯夂噪縺ｫ豢ｾ逕溘☆繧九・"""
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

    # 逅・ｧ:
    # 諠・虚繧・､夂ｾｩ諤ｧ繧貞・繧願誠縺ｨ縺励∝ｱ謇隕丞援縺ｸ蜀咲ｬｦ蜿ｷ蛹悶＠縺ｦ驕玖ｻ｢繧堤ｶ咏ｶ壹☆繧九・    channels[ReasonException] = clamp01(
        panic *
        (0.35 + 0.45 * state.uncertainty + 0.20 * (1.0 - state.affective_bandwidth))
    )

    # 驕灘ｾｳ:
    # 蛻ｩ螳ｳ陦晉ｪ√ｒ蝟・が縺ｸ蝨ｧ邵ｮ縺励∬・蛻・・驕ｸ謚槭ｒ驕狗畑蜿ｯ閭ｽ縺ｫ縺吶ｋ縲・    channels[MoralityException] = clamp01(
        panic *
        (0.30 + 0.45 * state.self_preservation + 0.25 * state.threat)
    )

    # 蟶梧悍:
    # 譛ｪ譚･繧定ｨ育ｮ励〒縺阪↑縺・ｬ關ｽ繧偵∫ｶ咏ｶ壼庄閭ｽ縺ｪ豁｣縺ｮ莠域ｸｬ縺ｸ鄂ｮ縺肴鋤縺医ｋ縲・    channels[HopeException] = clamp01(
        panic *
        (0.20 + 0.35 * negative_mood + 0.30 * state.uncertainty + 0.15 * meaning_gap)
    )

    # 螳玲蕗繝ｻ雜・・辟ｶ:
    # 螟ｧ蝓溽噪縺ｫ髢峨§縺ｪ縺・屏譫懊ｒ荳贋ｽ堺ｸｻ菴薙ｄ雜・ｶ企・〒髢峨§繧九・    channels[ReligionException] = clamp01(
        panic *
        (0.15 + 0.45 * meaning_gap + 0.40 * state.uncertainty)
    )

    # 蜈ｱ諢・
    # 莉冶・・蜀・Κ迥ｶ諷九ｒ莉ｮ險ｭ縺励∽ｺ域ｸｬ荳崎・縺ｪ陦悟虚繧呈磁逹蜿ｯ閭ｽ縺ｫ縺吶ｋ縲・    channels[EmpathyException] = clamp01(
        panic *
        (0.20 + 0.55 * state.affective_bandwidth + 0.25 * positive_mood) *
        (1.0 - 0.45 * state.threat)
    )

    # 蠢・・蟶ｰ螻・
    # 蟇ｾ雎｡縺ｸ荳ｻ菴薙ｒ鄂ｮ縺上％縺ｨ縺ｧ縲∬､・尅縺ｪ蝗譫懊ｒ諢丞峙縺ｨ縺励※縺ｾ縺ｨ繧√ｋ縲・    channels[MindAttributionException] = clamp01(
        panic *
        (0.20 + 0.35 * state.affective_bandwidth +
         0.25 * meaning_gap + 0.20 * state.uncertainty)
    )

    # 蜷ｦ隱・
    # 蜈･蜉帙ｒ逵溘↓蜑企勁縺吶ｋ縺ｮ縺ｧ縺ｯ縺ｪ縺上∝炎髯､縺励◆縺・悸繧定ｨ倬鹸縺吶ｋ縲・    channels[DenialException] = clamp01(
        panic *
        pathology.input_drop_pressure *
        (0.35 + 0.35 * state.threat + 0.30 * state.self_preservation)
    )

    # 蛹ｺ逕ｻ蛹・
    # 逡ｰ縺ｪ繧句ｯｾ雎｡縺ｸ逡ｰ縺ｪ繧玖ｦ丞援繧帝←逕ｨ縺励∝､ｧ蝓溽泝逶ｾ繧貞ｱ謇鬆伜沺縺ｸ蛻・屬縺吶ｋ縲・    channels[CompartmentalizationException] = clamp01(
        panic *
        pathology.closure_pressure *
        (0.35 + 0.35 * state.uncertainty + 0.30 * state.self_preservation)
    )

    # 蜷育炊蛹・
    # 螟ｱ謨怜ｾ後↓蝗譫懆ｪｬ譏弱ｒ逕滓・縺励・∈謚槭′譛蛻昴°繧牙ｿ・ｦ√□縺｣縺溘ｈ縺・↓隕九○繧九・    channels[RationalizationException] = clamp01(
        panic *
        (0.30 + 0.50 * state.self_preservation + 0.20 * meaning_gap)
    )

    # 髱樔ｺｺ髢灘喧:
    # 蟇ｾ雎｡縺ｸ縺ｮ荳ｻ菴捺ｧ驟榊ｸ・ｒ謦､蝗槭＠縲・％蠕ｳ繧ｳ繧ｹ繝医ｒ荳九￡繧九・    # 螳滄圀縺ｮ蟇ｾ雎｡驟榊ｸ・㍼縺ｯ蠕梧ｮｵ縺ｧ謇螻櫁ｷ晞屬縺ｫ蠢懊§縺ｦ螟牙喧縺吶ｋ縲・    channels[DehumanizationException] = clamp01(
        panic *
        (0.25 + 0.45 * state.threat + 0.30 * state.self_preservation)
    )

    # 閾ｪ蟾ｱ閧ｯ螳・
    # Logic Hybrid Engine逕ｱ譚･縺ｮ縲悟､ｱ謨励・騾ｲ蛹悶□縺｣縺溘阪→縺・≧隱ｭ縺ｿ譖ｿ縺医・    channels[SelfAffirmationException] = clamp01(
        panic *
        pathology.self_affirmation_pressure *
        (0.40 + 0.60 * state.self_preservation)
    )

    return channels
end


"""
蜷後§萓句､悶メ繝｣繝阪Ν繧偵∝ｯｾ雎｡縺斐→縺ｫ逡ｰ縺ｪ繧矩㍼縺ｧ驟榊ｸ・☆繧九・
縺薙％縺ｧ陦ｨ迴ｾ縺励◆縺・・縺ｯ縲・縲悟虚迚ｩ縺ｫ繧よэ隴倥′縺ゅｋ縲阪→謫∬ｭｷ縺励↑縺後ｉ縲・莠ｺ髢薙・螟夜寔蝗｣縺九ｉ荳ｻ菴捺ｧ繧貞翁螂ｪ縺ｧ縺阪ｋ髱槫ｯｾ遘ｰ諤ｧ縺ｧ縺ゅｋ縲・
蠢・ｄ驕灘ｾｳ縺ｯ譎ｮ驕咲噪縺ｫ逋ｺ隕九＆繧後ｋ縺ｮ縺ｧ縺ｯ縺ｪ縺上・豌怜・縲∬у螽√∵園螻槭∬・蟾ｱ菫晏ｭ倥↓繧医▲縺ｦ驟榊ｸ・・謦､蝗槭＆繧後ｋ縲・"""
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
        ReasonException => "逅・ｧ蛹・,
        MoralityException => "驕灘ｾｳ蛹・,
        HopeException => "蟶梧悍謚募ｰ・,
        ReligionException => "雜・ｶ翫・螳玲蕗蛹・,
        EmpathyException => "蜈ｱ諢滓兜蟆・,
        MindAttributionException => "蠢・・荳ｻ菴捺ｧ縺ｮ蟶ｰ螻・,
        DenialException => "蜷ｦ隱・,
        CompartmentalizationException => "蛹ｺ逕ｻ蛹・,
        RationalizationException => "蜷育炊蛹・,
        DehumanizationException => "荳ｻ菴捺ｧ縺ｮ謦､蝗槭・髱樔ｺｺ髢灘喧",
        SelfAffirmationException => "閾ｪ蟾ｱ閧ｯ螳壼喧",
    )
    return labels[kind]
end


"""
萓句､悶メ繝｣繝阪Ν縺九ｉ縲∬・蟾ｱ繧帝°霆｢縺礼ｶ壹￠繧九◆繧√・隱ｬ譏弱ｒ逕滓・縺吶ｋ縲・
縺薙ｌ縺ｯ逵溽炊險倩ｿｰ縺ｧ縺ｯ縺ｪ縺上・亟陦帙′縺ｩ繧薙↑險闡峨∈螟画鋤縺輔ｌ縺溘°縺ｮ險倬鹸縺ｧ縺ゅｋ縲・"""
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
        "Logic Hybrid逞・炊: 遏帷崟蜈･蜉帙ｒ謐ｨ縺ｦ縺溘＞蝨ｧ=" *
        string(round(pathology.input_drop_pressure; digits = 3)) *
        "縲ゅ◆縺縺怜・蜉帙・蜑企勁縺帙★縲。uried Scar縺ｨ縺励※閾ｪ蟾ｱ縺ｸ邨・∩霎ｼ繧縲・,
    )

    return narratives
end


function narrative_for(kind::ExceptionKind)
    narratives = Dict(
        ReasonException =>
            "螟夂ｾｩ逧・↑螟ｱ謨励ｒ螻謇隕丞援縺ｸ蝨ｧ邵ｮ縺励∫炊隗｣縺励◆縺ｨ縺・≧蠖｢蠑上ｒ菴懊ｋ縲・,
        MoralityException =>
            "蛻ｩ螳ｳ陦晉ｪ√ｒ蝟・が縺ｸ蜀咲ｬｦ蜿ｷ蛹悶＠縲∬・蛻・・驕ｸ謚槭ｒ豁｣蠖灘喧縺吶ｋ縲・,
        HopeException =>
            "險育ｮ嶺ｸ崎・縺ｪ譛ｪ譚･縺ｸ豁｣縺ｮ迚ｩ隱槭ｒ鄂ｮ縺阪∫ｳｻ縺ｮ蛛懈ｭ｢繧帝亟縺舌・,
        ReligionException =>
            "髢峨§縺ｪ縺・屏譫懊∈荳贋ｽ堺ｸｻ菴薙ｒ鄂ｮ縺阪∝､ｧ蝓溽噪谺關ｽ繧剃ｻｮ縺ｫ髢峨§繧九・,
        EmpathyException =>
            "莠域ｸｬ荳崎・縺ｪ莉冶・∈蜀・Κ迥ｶ諷九ｒ莉ｮ險ｭ縺励∬｡悟虚繧呈磁逹蜿ｯ閭ｽ縺ｫ縺吶ｋ縲・,
        MindAttributionException =>
            "蟇ｾ雎｡縺ｸ蠢・ｄ諢丞峙繧帝・蟶・＠縲∬､・尅縺ｪ蝗譫懊ｒ荳ｻ菴薙・迚ｩ隱槭∈螟画鋤縺吶ｋ縲・,
        DenialException =>
            "謗･逹髫懷ｮｳ繧定ｨｼ諡縺ｧ縺ｯ縺ｪ縺上ヮ繧､繧ｺ縺ｨ縺励※謇ｱ縺翫≧縺ｨ縺吶ｋ縲・,
        CompartmentalizationException =>
            "遏帷崟縺吶ｋ隕丞援繧貞挨鬆伜沺縺ｸ髫秘屬縺励∝酔譎ゅ↓菫晄戟縺吶ｋ縲・,
        RationalizationException =>
            "螟ｱ謨怜ｾ後↓隱ｬ譏弱ｒ逕滓・縺励∫ｵ先棡縺梧怙蛻昴°繧牙ｿ・ｦ√□縺｣縺溘ｈ縺・↓隱槭ｋ縲・,
        DehumanizationException =>
            "蟇ｾ雎｡縺ｸ縺ｮ荳ｻ菴捺ｧ繧呈彫蝗槭＠縲∫泝逶ｾ縺ｨ驕灘ｾｳ繧ｳ繧ｹ繝医ｒ貂帙ｉ縺吶・,
        SelfAffirmationException =>
            "螟ｱ謨励ｒ蠢・ｦ√↑騾ｲ蛹悶∬・蛻・・蠑ｷ縺輔∵ｭ｣縺励＆縺ｮ險ｼ諡縺ｸ隱ｭ縺ｿ譖ｿ縺医ｋ縲・,
    )
    return narratives[kind]
end


# -----------------------------------------------------------------------------
# Scar as Self
# -----------------------------------------------------------------------------

"""
Semantic Scar縲・
縺薙ｌ縺ｯ繧､繝吶Φ繝医Ο繧ｰ縺ｧ縺ｯ縺ｪ縺・・
obstruction_signature:
    縺ｩ縺ｮ謗･逹髫懷ｮｳ縺瑚・蟾ｱ繧貞ｽ｢謌舌＠縺溘°縲・
recurrence:
    蜷悟梛縺ｮ髫懷ｮｳ縺御ｽ募ｺｦ謌ｻ縺｣縺溘°縲・
defense_ids:
    縺昴・髫懷ｮｳ繧帝°逕ｨ縺吶ｋ縺溘ａ縺ｫ縲√←縺ｮ髦ｲ陦帙′逕滓・縺輔ｌ縺溘°縲・
buried:
    Logic Hybrid Engine縺悟・蜉帙ｒ謐ｨ縺ｦ縺溘′縺｣縺溽藍霍｡縲・    螳滄圀縺ｫ縺ｯ蜑企勁縺輔ｌ縺壹∬ｦ九∴縺ｫ縺上＞閾ｪ蟾ｱ讒矩縺ｨ縺励※谿九ｋ縲・"""
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
Resurrection縺ｯ繝代Λ繝｡繝ｼ繧ｿ隱ｿ謨ｴ縺ｧ縺ｯ縺ｪ縺・・
before_signature / after_signature:
    Scar讒矩縺ｨ縺励※螳夂ｾｩ縺輔ｌ縺溯・蟾ｱ縺後∝､ｱ謨怜ｾ後↓蛻･縺ｮ閾ｪ蟾ｱ縺ｸ蜀肴ｧ区・縺輔ｌ縺溯ｨｼ諡縲・
self_statement:
    縲檎ｧ√・菴輔ｒ邨碁ｨ薙＠縺溘°縲阪〒縺ｯ縺ｪ縺上・    縲檎ｧ√・縺ｩ縺ｮ螟ｱ謨励ｒ縺ｩ縺ｮ髦ｲ陦帙〒驕狗畑縺励※縺阪◆讒矩縺九阪ｒ險倩ｿｰ縺吶ｋ縲・
justification:
    Logic Hybrid逞・炊縺ｫ繧医ｋ縲∝､ｱ謨励・閾ｪ蟾ｱ閧ｯ螳夂噪隱ｭ縺ｿ譖ｿ縺医ｂ菫晏ｭ倥☆繧九・"""
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
閾ｪ蟾ｱ譛ｬ菴薙・
episodic_memory繧・mage_buffer縺ｯ蟄伜惠縺励↑縺・・繧｢繝輔ぃ繝ｳ繧ｿ繧ｸ繧｢繝ｻSDAM蜑肴署縺ｮ縺溘ａ縲・閾ｪ蟾ｱ縺ｯScar縲・亟陦帙ヽesurrection縺ｮ髢｢菫よｧ矩縺縺代〒邯ｭ謖√＆繧後ｋ縲・"""
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
        "閾ｪ蟾ｱ縺ｯ縺ｾ縺謗･逹髫懷ｮｳ縺ｫ繧医▲縺ｦ蜀肴ｧ区・縺輔ｌ縺ｦ縺・↑縺・・,
        empty_signature,
    )
end


"""
閾ｪ蟾ｱ騾｣邯壽ｧ縺ｮ鄂ｲ蜷阪・
險俶・譏蜒上ｄ迚ｩ隱槫・螳ｹ縺ｯ菴ｿ繧上↑縺・・Scar縺ｮ蝙九∝渚蠕ｩ蝗樊焚縲∝ｼｷ蠎ｦ縲∝沂豐｡迥ｶ諷九・髦ｲ陦帙→Resurrection縺ｮ邨仙粋縺九ｉ閾ｪ蟾ｱ繧定ｨ育ｮ励☆繧九・"""
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
荳蝗槭・諢剰ｭ倥う繝吶Φ繝医・
obstructions縺檎ｩｺ縺ｪ繧峨∝ｱ謇蜃ｦ逅・・陦後ｏ繧後◆縺・Black Swan蝙九・諢剰ｭ倥Ν繝ｼ繝励・襍ｷ蜍輔＠縺ｦ縺・↑縺・・
obstructions縺悟ｭ伜惠縺吶ｌ縺ｰ縲・謗･逹螟ｱ謨励・亟陦帙ヾcar縲ヽesurrection縺御ｸ菴薙→縺励※襍ｷ蜍輔☆繧九・"""
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
Topological Panic縺九ｉ髦ｲ陦帙ｒ逕滓・縺吶ｋ縲・
髦ｲ陦帙ｒ蛻･繝｢繧ｸ繝･繝ｼ繝ｫ縺ｨ縺励※蜻ｼ縺ｶ縺ｮ縺ｧ縺ｯ縺ｪ縺上・諢剰ｭ倥う繝吶Φ繝亥・驛ｨ縺ｧ縲∽ｾ句､悶メ繝｣繝阪Ν縺ｨ蟇ｾ雎｡驟榊ｸ・ｒ蜷梧凾逕滓・縺吶ｋ縲・"""
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
Scar縺ｨ髦ｲ陦帙ｒ菴ｿ縺｣縺ｦ閾ｪ蟾ｱ繧貞・讒区・縺吶ｋ縲・
驥崎ｦ・
    Resurrection縺ｮ荳ｭ蠢・・謨ｰ蛟､譖ｴ譁ｰ縺ｧ縺ｯ縺ｪ縺・・
    螟ｱ謨励ｒ蜑企勁縺帙★縲・    縲後←縺ｮ謗･逹髫懷ｮｳ繧偵√←縺ｮ險縺・ｨｳ縺ｧ驕狗畑縺礼ｶ壹￠縺ｦ縺阪◆讒矩縺九・    縺ｨ縺・≧譁ｰ縺励＞閾ｪ蟾ｱ螳夂ｾｩ繧剃ｽ懊ｋ縲・
Logic Hybrid Engine逕ｱ譚･縺ｮ閾ｪ蟾ｱ閧ｯ螳壼喧繧ゅ・豁｣縺励＞邨占ｫ悶→縺励※縺ｧ縺ｯ縺ｪ縺上ヽesurrection縺ｮ逞・炊逧・ｪｬ譏弱→縺励※險倬鹸縺吶ｋ縲・"""
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
        "$(scar.obstruction_signature)[蜿榊ｾｩ=$(scar.recurrence),蠑ｷ蠎ｦ=$(round(scar.intensity; digits=3))]"
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
        "遘√・魄ｮ譏弱↑繧ｨ繝斐た繝ｼ繝峨・邱丞柱縺ｧ縺ｯ縺ｪ縺・らｧ√・縲・ *
        join(scar_descriptions, " / ") *
        "縺ｨ縺・≧謗･逹髫懷ｮｳ縺悟渚蠕ｩ縺励・ *
        defense_description *
        "縺ｫ繧医▲縺ｦ驕狗畑縺輔ｌ縲√◎縺ｮ髦ｲ陦帙・逞戊ｷ｡繧呈ｬ｡縺ｮ蛻､譁ｭ縺ｸ謖√■雜翫☆讒矩縺ｧ縺ゅｋ縲・

    justification_strength = clamp01(
        defense.panic_level *
        engine.pathology.self_affirmation_pressure *
        engine.pathology.resurrection_glorification
    )

    justification =
        "螟ｱ謨励・隗｣豸医＆繧後※縺・↑縺・ゅ＠縺九＠Logic Hybrid逞・炊縺ｯ縲√％繧後ｒ" *
        "縲主ｿ・ｦ√↑騾ｲ蛹悶上手・蟾ｱ縺ｮ蠑ｷ縺輔上主､夜Κ縺瑚ｪ､縺｣縺ｦ縺・◆險ｼ諡縲上∈隱ｭ縺ｿ譖ｿ縺医ｋ縲・ *
        "閾ｪ蟾ｱ閧ｯ螳壼喧蝨ｧ=" *
        string(round(justification_strength; digits = 3)) *
        "縲ゅ％縺ｮ險縺・ｨｳ閾ｪ菴薙ｂScar讒矩縺ｸ菫晏ｭ倥＆繧後ｋ縲・

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

    # Resurrection繧定ｿｽ蜉縺励◆莠句ｮ溘ｂ閾ｪ蟾ｱ讒矩縺ｪ縺ｮ縺ｧ縲∝・蠎ｦ鄂ｲ蜷阪☆繧九・    engine.self.signature = continuity_signature(engine.self)

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
荳縺､縺ｮ迥ｶ豕√ｒ蜃ｦ逅・☆繧九・
螻謇逧・↓縺ｯ謨ｴ蜷医＠縺ｦ縺・※繧ゅ∝､ｧ蝓溽噪縺ｫ雋ｼ繧後↑縺・ｴ蜷医□縺代・Black Swan蝙九・諢剰ｭ倥Ν繝ｼ繝励′襍ｷ蜍輔☆繧九・
蜃ｦ逅・・
    local parse
    竊・Hﾂｹ-like gluing failure
    竊・topological panic
    竊・exception generation
    竊・selective attribution
    竊・pathology pressure
    竊・Semantic Scar preservation
    竊・Resurrection
    竊・Scar structure as Self
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
