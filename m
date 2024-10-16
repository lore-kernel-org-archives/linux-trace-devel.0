Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140C918595F
	for <linux-trace-devel@vger.kernel.org>; Wed, 16 Oct 2024 16:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729096532; cv=none; b=lzk7+aof/QHpGesg9LF86C0bAWETnfIZ4HijWXMNYLuDjyG3/hy/VmvL1IawwzjMMfXUzZkBUuLCRvZ8WF9hoq19WJLslPl87Z49bc01PBMy9C1LK2z3T7rOMrZzaCDXBXzpLkhjeI5WBHmdtkPVKtatQyTIx9fdZhvSl25yQRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729096532; c=relaxed/simple;
	bh=gDUPsdHiUmfs6n+lQzgpCZhOd30o10VfpNjcCyZW6u0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=luzACtxlxqDE99tGU8w3GJIYf9fdw5PjsCDKBg7+i/FdoVh+PhD2qHtxvhhFTSFOCoEliLdxDOOicekVYiFOj0ZgJr0ATD16OJ27+2Dn0iFXiXUJgZfLvC2zto/yls5NxM0Z151oGYsd5je2WiXyBvjj4OAyyvDb+raju/xmtQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC53C4CEC5
	for <linux-trace-devel@vger.kernel.org>; Wed, 16 Oct 2024 16:35:31 +0000 (UTC)
Date: Wed, 16 Oct 2024 12:35:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Destroy synthetic and eprobes before other
 events
Message-ID: <20241016123552.55efa78f@gandalf.local.home>
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

Synthetic events can be based on eprobes and other dynamic events. When
destroying multiple events via tracefs_dynevent_destroy() make sure to
remove the synthetic events first, followed by eprobes (as they can be on
other dynamic events as well), then the rest of the dynamic events.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-dynevents.c | 42 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 6df7212fb38e..77bdf94fdbfe 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -654,6 +654,22 @@ tracefs_dynevent_get(enum tracefs_dynevent_type type, const char *system,
 	return devent;
 }
 
+static int destroy_dynevents(struct tracefs_dynevent **all, bool force)
+{
+	int ret = 0;
+	int i;
+
+	if (!all)
+		return 0;
+
+	for (i = 0; all[i]; i++) {
+		if (tracefs_dynevent_destroy(all[i], force))
+			ret = -1;
+	}
+
+	return ret;
+}
+
 /**
  * tracefs_dynevent_destroy_all - removes all dynamic events of given types from the system
  * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
@@ -671,16 +687,32 @@ int tracefs_dynevent_destroy_all(unsigned int types, bool force)
 {
 	struct tracefs_dynevent **all;
 	int ret = 0;
-	int i;
 
+	/*
+	 * Destroy synthetic events first, as they may depend on
+	 * other dynamic events.
+	 */
+	if (types & TRACEFS_DYNEVENT_SYNTH) {
+		all = tracefs_dynevent_get_all(TRACEFS_DYNEVENT_SYNTH, NULL);
+		ret = destroy_dynevents(all, force);
+		tracefs_dynevent_list_free(all);
+		types &= ~TRACEFS_DYNEVENT_SYNTH;
+	}
+
+	/* Eprobes may depend on other events as well */
+	if (types & TRACEFS_DYNEVENT_EPROBE) {
+		all = tracefs_dynevent_get_all(TRACEFS_DYNEVENT_EPROBE, NULL);
+		ret |= destroy_dynevents(all, force);
+		tracefs_dynevent_list_free(all);
+		types &= ~TRACEFS_DYNEVENT_EPROBE;
+	}
+
+	/* Destroy the rest */
 	all = tracefs_dynevent_get_all(types, NULL);
 	if (!all)
 		return 0;
 
-	for (i = 0; all[i]; i++) {
-		if (tracefs_dynevent_destroy(all[i], force))
-			ret = -1;
-	}
+	ret |= destroy_dynevents(all, force);
 
 	tracefs_dynevent_list_free(all);
 
-- 
2.45.2

