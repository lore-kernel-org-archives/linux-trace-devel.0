Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01484326D51
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Feb 2026 23:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770161663; cv=none; b=UZ+KKX+t5IvvEBZPrj2ODwYlLLk+ysDlnyj136CW+hC34EbSI53PQTFnKRRA1PCgEBgjTQxXZt4WlmnlyiDdPEqPvdD+N/vZTonLJWXVXheruNQPKBfooVBWMAH75fQjJkWDeLlW5tkDjmXRfVQxq9nPA9DHN+f0ZQiei3cq5kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770161663; c=relaxed/simple;
	bh=/diZoBjDE+GdAlJ3wwzBsgefV6LpNJOiYLRKM8+if0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEuCaCtNvAanpbAGCwBTzu08/KSBmHbxY3rWrCAyBrPG6yLkRhWpF+QnIZ+sDthYx6CuNkFOmww09QQHIKX9Bzrqgrg5P+H57i0CJh1R/V7UxbGt3tXGQJHlVRpCOGzragG6+JtCO1c3Nm83h6DFIxqGGC3PU18yPW/WT4EqDNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC78C116D0;
	Tue,  3 Feb 2026 23:34:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnPv2-00000008tFP-2S0H;
	Tue, 03 Feb 2026 18:34:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 1/6] libtracecmd: Remove "compress" parameter from save_string_section()
Date: Tue,  3 Feb 2026 18:32:24 -0500
Message-ID: <20260203233451.2118849-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203233451.2118849-1-rostedt@goodmis.org>
References: <20260203233451.2118849-1-rostedt@goodmis.org>
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
index b981baf33ac4..6becaa1f8619 100644
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
 
@@ -610,9 +610,9 @@ static int update_endian_4(struct tracecmd_output *handle,
 	return 0;
 }
 
-static int save_string_section(struct tracecmd_output *handle, bool compress)
+static int save_string_section(struct tracecmd_output *handle)
 {
-	enum tracecmd_section_flags flags = 0;
+	enum tracecmd_section_flags flags = TRACECMD_SEC_FL_COMPRESS;
 	tsize_t offset;
 
 	if (!handle->strings || !handle->strings_p)
@@ -624,18 +624,16 @@ static int save_string_section(struct tracecmd_output *handle, bool compress)
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
@@ -649,7 +647,7 @@ static int save_string_section(struct tracecmd_output *handle, bool compress)
 	return 0;
 
 error:
-	tcmd_out_compression_reset(handle, compress);
+	tcmd_out_compression_reset(handle, true);
 	return -1;
 }
 
@@ -2158,7 +2156,7 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle)
 	if (!HAS_SECTIONS(handle))
 		return 0;
 
-	return save_string_section(handle, true);
+	return save_string_section(handle);
 }
 
 int tracecmd_write_options(struct tracecmd_output *handle)
-- 
2.51.0

