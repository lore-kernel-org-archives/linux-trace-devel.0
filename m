Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B04825B1EA
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Jul 2025 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753993340; cv=none; b=oxpQT8NSRA9VJheAdo0zfszi1KT6/Ddjhh+RHH/g72Gerzme8QvNfVBEelhnaFspAJrF6ZRjPY69TQ1QHBplD1zcxkDntKkJdkRkPUAsyuLNlF9TdfInnN11X9akzl5pI4Y8az1cyYCKzz95aznpRvemOvstaUm9ry7tXfygvs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753993340; c=relaxed/simple;
	bh=Su/tEdiDxJKxJSnnr5L1OAJcszY4dcBb6TMc2Ze6waI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfwWBfGWbaf/PJ2FBqWQ0+uEA49RzAiTGpJW4Jh+G0jxoOcLDcclB12Ku/BeZ0KpM2Ha8yzwYgtTJcVu+3a4vQU5qCeG9RAuA3pzmRJQsjwiIc0274fpwcH1IhkbKneN7GwAV8yF1gtEr+eEpEdo/LPsEGfTBtJ71rsc99SJRsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F11FC4CEEF;
	Thu, 31 Jul 2025 20:22:20 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1uhZnT-00000006wR9-2uCx;
	Thu, 31 Jul 2025 16:22:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/5] libtracecmd: Remove "compress" parameter from save_string_section()
Date: Thu, 31 Jul 2025 16:20:34 -0400
Message-ID: <20250731202238.1654368-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250731202238.1654368-1-rostedt@goodmis.org>
References: <20250731202238.1654368-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function save_string_section() is always called with the compress
parameter as "true". There's no reason to have it. Just always make it true.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c333553ebf67..e7399d686313 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -97,7 +97,7 @@ struct list_event_system {
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
 static int write_options(struct tracecmd_output *handle);
-static int save_string_section(struct tracecmd_output *handle, bool compress);
+static int save_string_section(struct tracecmd_output *handle);
 
 __hidden long long
 tcmd_do_write_check(struct tracecmd_output *handle, const void *data, long long size)
@@ -290,7 +290,7 @@ void tracecmd_output_flush(struct tracecmd_output *handle)
 		write_options(handle);
 
 		/* write strings section */
-		save_string_section(handle, true);
+		save_string_section(handle);
 	}
 }
 
@@ -577,9 +577,9 @@ __hidden int tcmd_out_update_section_header(struct tracecmd_output *handle, tsiz
 	return 0;
 }
 
-static int save_string_section(struct tracecmd_output *handle, bool compress)
+static int save_string_section(struct tracecmd_output *handle)
 {
-	enum tracecmd_section_flags flags = 0;
+	enum tracecmd_section_flags flags = TRACECMD_SEC_FL_COMPRESS;
 	tsize_t offset;
 
 	if (!handle->strings || !handle->strings_p)
@@ -591,18 +591,16 @@ static int save_string_section(struct tracecmd_output *handle, bool compress)
 		return -1;
 	}
 
-	if (compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_STRINGS, "strings", flags, false);
 	if (offset == (off_t)-1)
 		return -1;
 
-	tcmd_out_compression_start(handle, compress);
+	tcmd_out_compression_start(handle, true);
 
 	if (tcmd_do_write_check(handle, handle->strings, handle->strings_p))
 		goto error;
 
-	if (tcmd_out_compression_end(handle, compress))
+	if (tcmd_out_compression_end(handle, true))
 		goto error;
 
 	if (tcmd_out_update_section_header(handle, offset))
@@ -616,7 +614,7 @@ static int save_string_section(struct tracecmd_output *handle, bool compress)
 	return 0;
 
 error:
-	tcmd_out_compression_reset(handle, compress);
+	tcmd_out_compression_reset(handle, true);
 	return -1;
 }
 
@@ -2122,7 +2120,7 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle)
 	if (!HAS_SECTIONS(handle))
 		return 0;
 
-	return save_string_section(handle, true);
+	return save_string_section(handle);
 }
 
 int tracecmd_write_options(struct tracecmd_output *handle)
-- 
2.47.2

