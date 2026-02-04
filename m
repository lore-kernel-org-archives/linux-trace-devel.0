Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCDE26738C
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770167762; cv=none; b=Pm7BQki4LKArj1T5bFtlsaGGIJf22/Ku4GM2mqWNWrGhwVSNh9ydynsH0YlaB9PChhvs9mIDiLOBy2OPKihEfr00k9XdDEd4BDJfeswcYerUBE5LNYia/95LE3APizfFBixOf2UzRs0kLit4m1hpd4ny2nyCdApsegI4KblOA2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770167762; c=relaxed/simple;
	bh=fwREQDNDhGA9kSHOebuEQtGU5S9YCq6d3DO9bYrWzeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOUpgIk/fImtoOE6S//rQ8PoOtoGOmFeSERP67Z9ax8gylF21jfEO/x8qKwFaq6SfCdwAj8AByMunUCj83805dnl6xT/EUYdQp7S8I5IKcfrckiwZPC2Sde3QCvwv6rLumCLU9QeFgjmYRKeoRehOIX90HY6A0MI0YFnouPLrhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E694FC2BC87;
	Wed,  4 Feb 2026 01:16:00 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnRVO-00000008xV7-41au;
	Tue, 03 Feb 2026 20:16:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] trace-cmd extract: Always read BTF file if available
Date: Tue,  3 Feb 2026 20:14:53 -0500
Message-ID: <20260204011629.2135260-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260204011629.2135260-1-rostedt@goodmis.org>
References: <20260204011629.2135260-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

On extract, always read the btf file as it isn't known yet if it will be
needed or not.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4872d0d77c8e..1cef9a623158 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4666,13 +4666,21 @@ static void check_need_btf(bool *need_btf, struct tracefs_instance *instance)
 	free(current);
 }
 
+#define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
+#define IS_START(ctx) ((ctx)->curr_cmd == CMD_start)
+#define IS_CMDSET(ctx) ((ctx)->curr_cmd == CMD_set)
+#define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
+#define IS_PROFILE(ctx) ((ctx)->curr_cmd == CMD_profile)
+#define IS_RECORD(ctx) ((ctx)->curr_cmd == CMD_record)
+#define IS_RECORD_AGENT(ctx) ((ctx)->curr_cmd == CMD_record_agent)
+
 static void record_data(struct common_record_context *ctx)
 {
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
 	bool have_proxy = false;
 	bool local = false;
-	bool need_btf = false;
+	bool need_btf = IS_EXTRACT(ctx);
 	int max_cpu_count = local_cpu_count;
 	char **temp_files;
 	int i;
@@ -6230,14 +6238,6 @@ static void init_common_record_context(struct common_record_context *ctx,
 	init_top_instance();
 }
 
-#define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
-#define IS_START(ctx) ((ctx)->curr_cmd == CMD_start)
-#define IS_CMDSET(ctx) ((ctx)->curr_cmd == CMD_set)
-#define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
-#define IS_PROFILE(ctx) ((ctx)->curr_cmd == CMD_profile)
-#define IS_RECORD(ctx) ((ctx)->curr_cmd == CMD_record)
-#define IS_RECORD_AGENT(ctx) ((ctx)->curr_cmd == CMD_record_agent)
-
 static void add_argv(struct buffer_instance *instance, char *arg, bool prepend)
 {
 	instance->argv = realloc(instance->argv,
-- 
2.51.0

