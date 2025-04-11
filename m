Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3472572
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 01:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744335095; cv=none; b=ekpXnAVRHEKHd/5IM1WdSfZZOK/kdz9n/K/nE+nYXQdmNLOqf9gsdRtLoyILdKVqeReo8IWtKAafwuXaCAAGEHngqNU178qcrSlsdibTVzNsX8xNQcsx1kru5mIOL3a3GkE0RhZAkXRxN6CMqYC8g/uWFPyPtHkglWdA8PteLFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744335095; c=relaxed/simple;
	bh=DX+WW81DnXgo+pvTZ6Zh9IUIeDCbatE5RvKw3uCEP0w=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=JeBTfvW+r21K6AMjnFYp6+GGrh9tPohe+yKdBNFxNtL7DtE8j1srvqlcAVUTCOS/orqpYlVrfndHFQUS1cCRV3ugFISpoJHYg5mE9nUEnLAkvwZsOJzmU82N5FyjTwEe/ZLFH9ebI1Hh6ZnnArpbYOVutjvSSXLgm2gSINE+E2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9AEC4CEDD
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 01:31:34 +0000 (UTC)
Date: Thu, 10 Apr 2025 21:32:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtacefs: Fix COMM for use as a field for
 tracefs_sqlhist()
Message-ID: <20250410213257.5e3550fd@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The COMM was added to be used as a filter, but it can also be used as a
field. In order to do that, the type must be correct. The type should just
be "char" and the array type should be a dynamic array.

Fixes: 9098ab0d ("libtracefs: Allow filters to use "COMM"")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-filter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index f1de372..3b0933f 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -36,9 +36,10 @@ static const struct tep_format_field common_timestamp_usecs = {
 };
 
 static const struct tep_format_field common_comm = {
-	.type			= "char *",
+	.type			= "char",
 	.name			= "common_comm",
-	.size			= 16,
+	.size			= 4,
+	.flags			= TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_DYNAMIC,
 };
 
 const struct tep_format_field tfs_common_stacktrace __hidden = {
-- 
2.47.2

