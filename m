Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7810126A0B9
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2026 19:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059136; cv=none; b=MnTqSwZl8qrtHLqbPW69xWr66/c5tCPqo9tg0zzuzdSwQYyXrdCY11tzWwlOU+76NI6pF8xYGXrk2G2zlBp54JPNFPKWKU4s0mNpqIep+V5ibePBYJm6lvVxmrNRTrC9h9MQWcNgBsuHG3cp1KeoXYiyUfDonNiGFJ0qEEVz/G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059136; c=relaxed/simple;
	bh=HmhKM2UQM5YUH0emXioaTy5SQDXiAFEwZ9xjMp781uY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=C8yoxsIMgd9T6r2TvQ7gAGZcSyxtkMnfhMoWwaC32hVLjecd05jnx5cxAktbtUdcr0T6cMvVOvSBllVZ3Z8DJnsGB/I7dMTSxpmQwki6tq4Qt9P2JAgNwA+fpUY1ppMg/x9cLzqSksYDpHFUloxWqm7v3cZaJvTwsSkotS5XGEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5AB78402E6;
	Fri, 24 Apr 2026 19:32:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id EBB7C20014;
	Fri, 24 Apr 2026 19:32:11 +0000 (UTC)
Date: Fri, 24 Apr 2026 15:32:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Jann Horn <jannh@google.com>
Subject: [PATCH] libtracecmd: Fix rb-tree deletion
Message-ID: <20260424153217.1a0a3aca@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pzfh3mixwtp96tgcju4h8uqimqwwwcm8
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: EBB7C20014
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+99O5q1XJWSFeTieehMG0rEqr+eEoEqnE=
X-HE-Tag: 1777059131-416246
X-HE-Meta: U2FsdGVkX1/Ip4U43dFI+/wY8tQNChhLSzqFslTn7JjKTx1glENbeR1t+gw6yC6Tpdnfe/uQu94K+2QAuK5lHHp9thS2GWikoOFqVP3tgYaakHca9ZCRdwUtyPvYhy053jWOHr/9GfIQ8Ll0W1ccA89YmWo1UzgHvrGdU53TwrRiCjCR7OeDfcmMWRR6le1T+Lq6w/yMpEZ7Bb0LBEKJ3FlavIXbv6AMcvTdltQA7kfTKt/7yi1ai313SMdewHWMyQw4LMJe23pAdFSOhZHq5ZKr/cZysRCQlim63N+54bACx6kukbumJ1u3El477A8WEJxY5TjspHmVVn8KHp7Ythwfz/KNJTs8cgjhth6J7uUe5RSLefPPTpuCkSQN9z9M99SPZJi5lERoh7rM2jSy4WKTnOPo0Lh3M85W0iUtOv4=

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The trace_rbtree_delete() does a fix up call if the y node is BLACK. It
calls the fixup code on the y node's left or right child. But if the y
node doesn't have any children, it crashes with a NULL pointer
dereference.

Use a "nil" node for the x child if it y had no children. This makes the
fixup code work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221171
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-rbtree.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-rbtree.c b/lib/trace-cmd/trace-rbtree.c
index a541399a1b4d..523881699440 100644
--- a/lib/trace-cmd/trace-rbtree.c
+++ b/lib/trace-cmd/trace-rbtree.c
@@ -26,6 +26,11 @@ static bool is_left(struct trace_rbtree_node *node)
 	return node == node->parent->left;
 }
 
+static bool is_black(struct trace_rbtree_node *node)
+{
+	return !node || node->color == BLACK;
+}
+
 static struct trace_rbtree_node **get_parent_ptr(struct trace_rbtree *tree,
 						 struct trace_rbtree_node *node)
 {
@@ -261,12 +266,12 @@ static void tree_fixup(struct trace_rbtree *tree, struct trace_rbtree_node *node
 				rotate_left(tree, node->parent);
 				old_right = node->parent->right;
 			}
-			if (old_right->left->color == BLACK &&
-			    old_right->right->color == BLACK) {
+			if (is_black(old_right->left) &&
+			    is_black(old_right->right)) {
 				old_right->color = RED;
 				node = node->parent;
 			} else {
-				if (old_right->right->color == BLACK) {
+				if (is_black(old_right->right)) {
 					old_right->left->color = BLACK;
 					old_right->color = RED;
 					rotate_right(tree, old_right);
@@ -287,12 +292,12 @@ static void tree_fixup(struct trace_rbtree *tree, struct trace_rbtree_node *node
 				rotate_right(tree, node->parent);
 				old_left = node->parent->left;
 			}
-			if (old_left->right->color == BLACK &&
-			    old_left->left->color == BLACK) {
+			if (is_black(old_left->right) &&
+			    is_black(old_left->left)) {
 				old_left->color = RED;
 				node = node->parent;
 			} else {
-				if (old_left->left->color == BLACK) {
+				if (is_black(old_left->left)) {
 					old_left->right->color = BLACK;
 					old_left->color = RED;
 					rotate_left(tree, old_left);
@@ -312,6 +317,7 @@ static void tree_fixup(struct trace_rbtree *tree, struct trace_rbtree_node *node
 void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *node)
 {
 	struct trace_rbtree_node *x, *y;
+	struct trace_rbtree_node nil;
 	bool do_fixup = false;
 
 	if (!node->left && !node->right && !node->parent) {
@@ -329,8 +335,14 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
 	else
 		x = y->right;
 
-	if (x)
-		x->parent = y->parent;
+	if (!x) {
+		x = &nil;
+		x->color = BLACK;
+		x->left = NULL;
+		x->right = NULL;
+	}
+
+	x->parent = y->parent;
 
 	if (!y->parent) {
 		tree->node = x;
@@ -365,6 +377,12 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
 	if (do_fixup)
 		tree_fixup(tree, x);
 
+	if (x == &nil) {
+		if (is_left(x))
+			x->parent->left = NULL;
+		else
+			x->parent->right = NULL;
+	}
  out:
 	node->parent = node->left = node->right = NULL;
 	tree->nr_nodes--;
-- 
2.53.0

