Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B53B2D0C9C
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762984157; cv=none; b=bv79btf8+T2fW52hYDRJDU1FilRqvDGXbdwrFXIk5t4E7QnkYLS1uv190QLh3NA9txoo6sftoFfcndWSR8sNp0DBJNsCWiuyaE5Mq2UT42ndPESOVhNd0W6Z6xF5vwe8c+32jHPmv3UZ40ybyyJdPLPDQccPyGtzj8OHZnMUcl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762984157; c=relaxed/simple;
	bh=PCFs8EX1eB4yYStFtFxKbzbKO1fT+jbNF1EXJwgWnIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtexiWp2BY60cHJkFoaalRenDbbBiDJY3nyUwiqGvqdK3Nc/M+sRvrI7SgbgcZzkvzbVi+TWPbJWR2iYR5WpEa0epbK2L+8cBYWTLmbumhYdr4XV/vmL8V7DT0tlE4rcetf6JgzZDjL8VWcc11ErSSHiPBIi3gXJxz0b2l3kceI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47EDC19425;
	Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vJIiY-00000001Dhd-3FzF;
	Wed, 12 Nov 2025 16:49:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 3/4] libtraceevent: Have BTF find functions with extra characters
Date: Wed, 12 Nov 2025 16:42:37 -0500
Message-ID: <20251112214929.290686-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112214929.290686-1-rostedt@goodmis.org>
References: <20251112214929.290686-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Sometimes the symbol of a function has extra characters followed by a '.'.
In this case, the BTF lookup may not find the function. If the function is
not found and the function name contains a '.', try stripping off the
extra characters and try again. That way, instead of:

  __mutex_unlock_slowpath.isra.0(ffffffffb5cd4e40, 8, 1, 1, ffffffffb43e0fe4, ffffed1024699f88)

It can produce:

  __mutex_unlock_slowpath.isra.0(lock=0xffffffffb5cd4e40, ip=0x8)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/trace-btf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/trace-btf.c b/src/trace-btf.c
index 12dc49447027..742cffd35edc 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -357,11 +357,23 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 	unsigned long long arg;
 	unsigned int encode;
 	const char *param_name;
+	const char *fp;
 	int a, p, x, nr;
 
 	if (size != 4 && size != 8)
 		return -1;
 
+	if (!type && (fp = strchr(func, '.'))) {
+		char *f;
+		/* func name has extra characters */
+		f = strdup(func);
+		if (f) {
+			f[fp - func] = '\0';
+			type = tep_btf_find_func(btf, f);
+			free(f);
+		}
+	}
+
 	if (!type) {
 		for (int i = 0; i < nmem; i++) {
 			assign_arg(&arg, args, size, i);
-- 
2.51.0

