function q = TransformQuadRule(q, p)

    bk = [p(:,2) - p(:,1), p(:,3) - p(:,1)];
    q.x = repmat(p(:,1), 1, size(q.x,2)) + bk * q.x;
    q.w = q.w * abs(det(bk));

end
