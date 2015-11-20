命中公式：
# 命中技巧、闪避技巧的贡献， 正常情况下 0.58， 不能为负数
hit_rate_hit = [3*(self.hit - target.eva) / self.hit, -0.5].max

# 敏捷的贡献，正常情况下0.30
hit_rate_cel = [(self.cel - target.cel) / self.cel, -1].max

# 防御的贡献， 正常情况下 0.10
hit_rate_def = [0.4*(self.def-target.def) / self.def, 0.4].max