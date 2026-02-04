Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C0527F195
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770169279; cv=none; b=kMUMnNmRMW6Hs99OAcmNc4eRpFttN/q7MnNAxxsvDff1uosHyAV70Mb4ax/KZ6S/s7benG1lb0vKgFL1pgWH9Zk6vsYEQI0NurkGm1kmV23q2jSnivS5x6Wf3r5jENLA/+wBOuNnfvH356/2x/aBsnCH0T1gJLUDbPyuPsUurmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770169279; c=relaxed/simple;
	bh=FCrPHArM0SF2B53kY5pUR2hTmBBNbyXlBl8asG/0Hlg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=JgeL1raP5pNlWOPLqNBYw/4ILJAZbAiEdCDShbVqrjz7UVcWzW+QI7aPDKibY2jhKyi7pGdGGafM+bDQrbpeUDIO+5MZo0QLKGbr4YfZnywgKe7/fDfNFUDgeAlOLdFMeqAGXcM9xto0tmCv8fSQYiCFa0ztkHxrL7DF8EJUwLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AF7513B55A;
	Wed,  4 Feb 2026 01:41:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id B390417;
	Wed,  4 Feb 2026 01:41:08 +0000 (UTC)
Date: Tue, 3 Feb 2026 20:41:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] trace-cmd record: Fix long options
Message-ID: <20260203204138.778a958c@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j6s6ngftj39fhm1neid3mfcfm5a8disu
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: B390417
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+8EjvMjDQm0l8QlepuSbcpcFbaDAu9W7o=
X-HE-Tag: 1770169268-740685
X-HE-Meta: U2FsdGVkX18yDMgghC3fpghCjuIAcm4+ZEbIJZWI4bTMk1nnq29S0V4O6Hpp0j43xmx4mvK2xq54fJ6mQFqNQP6IupERhQef5cPQyyul2P0cBwPd3YY3aO3JLFjG7xZSPrXKzWiUbL2gY46UdS/1+aM2PS8ECRYYrbHzyj2axpjx2TNexR+EsgBwO4SwV+HVHP94jw+YgCuyzDY8fpaSs4socnQ2RVBPcfoQB6eTnJf924GKX4ePSOpKs5TDMI26ftQOClaGEM167BERTT+1mn8uUwRb8DHCIner39syEorkZi1OaiDyiKwkLznWg6hffxOnAPy6a1GmXESNno/jvmmjSeAN9gK354EY/7iNuRtocADZj5/l2bYYTmIK2Cq0LjJ6oUGJJ9EuGtI/ptAedEYjLN8ZdfA7aAgetMUZSdE=

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The long options use to start at 255 and work its way down, but then
commit c9331817fa52a ("trace-cmd record: Add module filtering option")
added an option at 256 (which is 0x100) and they moved upward from there.

The guest code would test if the option was long or short by comparing the
number of the parameter to 0x80. If it was set, it was considered a long
option. This worked when the options were 255 and less (down to 128), but
as the numbers went up, 0x100 (256) & 0x80 is false and the option would
be ignored by guests.

Instead, for all long options to have 0x80 set to determine if it is a
long option or not. Use macros LONG_OPT() to set the long option value to
be 0x80 + (opt # << 8) and test if it is long via IS_LONG_OPT() that
simply tests 0x80.

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Tested-by: Marcelo Tosatti <mtosatti@redhat.com>
Fixes: 76aaeb474ca0b ("trace-cmd: Add VM kernel tracing over vsockets transport")
Closes: https://lore.kernel.org/all/aPu6yVSp0BtyNXc2@tpad/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 63 +++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a1f9b2363e9d..9fbd60a99ec7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6000,36 +6000,39 @@ void init_top_instance(void)
 	init_instance(&top_instance);
 }
 
+#define LONG_OPT(opt)		(0x80 + ((opt) << 8))
+#define IS_LONG_OPT(opt)	((opt) & 0x80)
+
 enum {
-	OPT_compression		= 237,
-	OPT_file_ver		= 238,
-	OPT_verbose		= 239,
-	OPT_tsc2nsec		= 240,
-	OPT_fork		= 241,
-	OPT_tsyncinterval	= 242,
-	OPT_user		= 243,
-	OPT_procmap		= 244,
-	OPT_quiet		= 245,
-	OPT_debug		= 246,
-	OPT_no_filter		= 247,
-	OPT_max_graph_depth	= 248,
-	OPT_tsoffset		= 249,
-	OPT_bycomm		= 250,
-	OPT_stderr		= 251,
-	OPT_profile		= 252,
-	OPT_nosplice		= 253,
-	OPT_funcstack		= 254,
-	OPT_date		= 255,
-	OPT_module		= 256,
-	OPT_nofifos		= 257,
-	OPT_cmdlines_size	= 258,
-	OPT_poll		= 259,
-	OPT_name		= 260,
-	OPT_proxy		= 261,
-	OPT_temp		= 262,
-	OPT_notimeout		= 264,
-	OPT_daemonize		= 265,
-	OPT_subbuf		= 266,
+	OPT_compression		= LONG_OPT(0),
+	OPT_file_ver		= LONG_OPT(1),
+	OPT_verbose		= LONG_OPT(2),
+	OPT_tsc2nsec		= LONG_OPT(3),
+	OPT_fork		= LONG_OPT(4),
+	OPT_tsyncinterval	= LONG_OPT(5),
+	OPT_user		= LONG_OPT(6),
+	OPT_procmap		= LONG_OPT(7),
+	OPT_quiet		= LONG_OPT(8),
+	OPT_debug		= LONG_OPT(9),
+	OPT_no_filter		= LONG_OPT(10),
+	OPT_max_graph_depth	= LONG_OPT(11),
+	OPT_tsoffset		= LONG_OPT(12),
+	OPT_bycomm		= LONG_OPT(13),
+	OPT_stderr		= LONG_OPT(14),
+	OPT_profile		= LONG_OPT(15),
+	OPT_nosplice		= LONG_OPT(16),
+	OPT_funcstack		= LONG_OPT(17),
+	OPT_date		= LONG_OPT(18),
+	OPT_module		= LONG_OPT(19),
+	OPT_nofifos		= LONG_OPT(20),
+	OPT_cmdlines_size	= LONG_OPT(21),
+	OPT_poll		= LONG_OPT(22),
+	OPT_name		= LONG_OPT(23),
+	OPT_proxy		= LONG_OPT(24),
+	OPT_temp		= LONG_OPT(25),
+	OPT_notimeout		= LONG_OPT(26),
+	OPT_daemonize		= LONG_OPT(27),
+	OPT_subbuf		= LONG_OPT(28),
 };
 
 void trace_stop(int argc, char **argv)
@@ -6282,7 +6285,7 @@ static void add_arg(struct buffer_instance *instance,
 	int i, ret;
 
 	/* Short or long arg */
-	if (!(c & 0x80)) {
+	if (!IS_LONG_OPT(c)) {
 		ptr = strchr(opts, c);
 		if (!ptr)
 			return; /* Not found? */
-- 
2.51.0

