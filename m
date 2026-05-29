Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9214410D0E
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 18:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780079663; cv=none; b=X9eUkc2Hvcwo3lpa+CsRSHQMYjQK5CSruWRD+2qVgDF5gb8c71K6Br3cUHoLpoCUSAltAIvfsSIFHowuqudUDKIwY8lidZyF5ZWU8spkWolodJSN/ldRWdM5Ja0XT78xFp1pOXFvY0vC4+GYM7fc43wq7kMyXtI0WyoKNhdkLlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780079663; c=relaxed/simple;
	bh=FG+AlCaPfgxVI3gffyP2+X/Npa6FDQAEFVtuG9n2nqA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=YLPuQElPqbXxrtU5jIxAerFO+gSUZDINcdrusJr/YDOz0NUAEv1vHZnmYYFCoweh+FAfWRjXHtsNyRPxEI7CZKVs0y1ZeZLQprj/BIahYzQ8BDff0QFROTBqInD+/AX/0XLY/b0gmW9YYAXkQ0c4G/6zSI78C+A/JBi0SeLHFOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0D68C013E
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 18:34:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id AB92B2002E
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 18:34:12 +0000 (UTC)
Date: Fri, 29 May 2026 14:34:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Have the rbtree check be more elaborate
Message-ID: <20260529143411.7ace2f59@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i15izdx7wbg6s8dakh75yj8nyebnypsn
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: AB92B2002E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+aU+QBKw9p8/EneP7b/GUXt/aqRxkgDo4=
X-HE-Tag: 1780079652-604114
X-HE-Meta: U2FsdGVkX19ToHdkQQD3HXcHmPK77VGRJzeQUk4lHg06DlPpRm5Ba4F6xBT+SQRFg6AYyTg3VknyI8892XcwPho9ZIQ640W40CeOudtloV+09FElR6GJL4gMcGcbpWgCVEsEWMkC9TrsTMLkeq1E+oW/fH/SpA3MoKVgvhAsPvD+rfk0Zl7468xOUvSv+8VBxN5s7CgtvYA7JTDI0+qCDs2uwq1S+v7qQMtZk196dnT5fiD7iPdhlkRv5WWDFEPwHSs4VlNynGK9x15ifJpIp2QcN7xFZpiDXgZSY7ZX4u1vWN2m8HBZO4NH+bwOLx6uZbjz8fx4j8uZ71/Y9ZTYX1/R6d2ylP5/8Mu9j0bVDPsj9AcBF6s9XBDaMA6bbeD/

From: Steven Rostedt <rostedt@goodmis.org>

Update the check_tree() that verifies the rbtree (when enabled) to be a
little more elaborate to find more errors with the tree.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-rbtree.c | 76 +++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 35 deletions(-)

diff --git a/lib/trace-cmd/trace-rbtree.c b/lib/trace-cmd/trace-rbtree.c
index a541399a1b4d..b8360900fcc7 100644
--- a/lib/trace-cmd/trace-rbtree.c
+++ b/lib/trace-cmd/trace-rbtree.c
@@ -114,10 +114,48 @@ static int check_node(struct trace_rbtree *tree, struct trace_rbtree_node *node)
 				goto fail;
 		}
 	}
+	if (node->color == RED) {
+		if (node->left && node->left->color == RED)
+			goto fail;
+		if (node->right && node->right->color == RED)
+			goto fail;
+	}
 	return 0;
 fail:
 	printf("FAILED ON NODE!");
-	breakpoint();
+	return -1;
+}
+
+static int check_tree_node(struct trace_rbtree *tree, struct trace_rbtree_node *node,
+			   int black)
+{
+	int this_black = black;
+	int left_black;
+	int right_black;
+
+	if (!node)
+		return 0;
+
+	this_black = node->color == BLACK;
+
+	if (check_node(tree, node) < 0)
+		goto fail;
+
+	if (node == node->left || node == node->right)
+		goto fail;
+
+	left_black = check_tree_node(tree, node->left, this_black);
+	right_black = check_tree_node(tree, node->right, this_black);
+
+	if (left_black < 0 || right_black < 0)
+		return -1;
+
+	if (left_black != right_black)
+		goto fail;
+
+	return this_black + left_black;
+fail:
+	printf("FAILED ON NODE!");
 	return -1;
 }
 
@@ -125,39 +163,7 @@ static void check_tree(struct trace_rbtree *tree)
 {
 	struct trace_rbtree_node *node = tree->node;
 
-	if (node) {
-		if (check_node(tree, node))
-			return;
-		while (node->left) {
-			node = node->left;
-			if (check_node(tree, node))
-				return;
-		}
-	}
-
-	while (node) {
-		if (check_node(tree, node))
-			return;
-		if (node->right) {
-			node = node->right;
-			if (check_node(tree, node))
-				return;
-			while (node->left) {
-				node = node->left;
-				if (check_node(tree, node))
-				    return;
-			}
-			continue;
-		}
-		while (node->parent) {
-			if (is_left(node))
-				break;
-			node = node->parent;
-			if (check_node(tree, node))
-				return;
-		}
-		node = node->parent;
-	}
+	check_tree_node(tree, node, 0);
 }
 #else
 static inline void check_tree(struct trace_rbtree *tree) { }
@@ -211,8 +217,8 @@ int __hidden tcmd_rbtree_insert(struct trace_rbtree *tree,
 			}
 		}
 	}
-	check_tree(tree);
 	tree->node->color = BLACK;
+	check_tree(tree);
 	tree->nr_nodes++;
 	return 0;
 }
-- 
2.53.0

