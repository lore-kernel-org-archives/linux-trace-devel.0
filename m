Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7376C2FE573
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Nov 2025 21:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156982; cv=none; b=OCggxv5DwzVMqoSLU9xCPl3A3VV7s8mdBikZzuP+yiwxPZaQRBkYl0HkJ+yv+gjxed6iGABt6RKnwJT7lX2IIamH2zVNi3Vwx7bsemEwEnEUKtFEl3cCdjlK5lgIPojUb3Q6/ZFF9XhhJeivvlHDZy5elg7MmsrLpjzt/Vm0LnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156982; c=relaxed/simple;
	bh=Y4sXDb6kyq8nnOP36pDKKBU+4vLAeh3yp6bUhDnqDSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiMlaH9A8G1geowWZ4eIvfpz2R2ftOPrk6op2nhCIjvTUijOztcEBfcrkG7YIWUyH92p9RUMxMAaZyTJmlnyfRctJMpj2VQm/kmhjEnfnvLG9BhkSiKWE1TqnbvlA4WDzQzJWqWa7ogWIPURlsoJz2dthsihw0JqSMWioPRq0b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24788C19421;
	Fri, 14 Nov 2025 21:49:42 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vK1g8-00000001yWr-46pV;
	Fri, 14 Nov 2025 16:50:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 6/6] trace-cmd documenatation: Update the trace.dat man page for BTF_FILE
Date: Fri, 14 Nov 2025 16:47:32 -0500
Message-ID: <20251114214959.470843-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251114214959.470843-1-rostedt@goodmis.org>
References: <20251114214959.470843-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that the trace.dat file has a way to store the BTF file, update the
documentation about it.

Link: https://lore.kernel.org/all/10187dcc-c054-4aa1-b8e1-758aba13a3df@arm.com/

Suggested-by: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
index 2f7e6a4a4654..73857d1a04f8 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
@@ -270,6 +270,11 @@ OPTIONS SECTION
       <string> a null terminated ASCII string, trace clock used for events timestamps in
       this trace instance.
 
+  BTF_FILE: id 23, size 8
+    The BTF_FILE option data is:
+     A compressed data from the host file /sys/kernel/btf/vmlinux, using the
+     compression algorthim defined by the trace.dat header. The compression data
+     includes the size of the uncompressed output.
 
 HEADER INFO SECTION
 -------------------
@@ -438,6 +443,20 @@ STRINGS SECTION
   meta data, which is the offset of the actual string into the string section. Strings can be stored
   into multiple string sections in the file.
 
+BTF FILE SECTION
+----------------
+
+  Section ID: 23
+
+  Directly after the section header comes the information mapping
+  a PID to a process name.
+
+  The next 8 bytes contain a 64-bit word that holds the size of the
+  data mapping the PID to a process name.
+
+  The next set of data is of the size defined by the previous 8 bytes
+  and contains the information from /sys/kernel/btf/vmlinux.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
-- 
2.51.0

