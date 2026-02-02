Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB68F3542E8
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Feb 2026 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071958; cv=none; b=YMgduhiOGmOViIbSscrdKL40l5nKkoJYqYvZ8gycSqI98GuV9U7w4IHvNJZ9J3olLus903KPmu1nBDdgL8g9fsz7G+NxA5Zz36jzgD1TnVHu72pDURkURrY+EygaE2cklLQXTE6tDWoNIbzTfU7Cq6E7Z7z+GRk3QBQOj6eFrWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071958; c=relaxed/simple;
	bh=Y4sXDb6kyq8nnOP36pDKKBU+4vLAeh3yp6bUhDnqDSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVV9NL5S63E3rbLQIle+H0KhU+o5/Z/ukAkgkHW7ucKGHYA2oWog+kehEmkH3pSXp19e+cMPk7huDfw2mc5lGhhIPKpm1jd1Nq3eU70onCJGV/XZzigg5bSeiSXK/20MMPTeDoiaXCwq0/Zl/iTXEeqdSmwat95rrbEZSrKjdlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718B9C4AF09;
	Mon,  2 Feb 2026 22:39:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vn2a8-00000008WeI-3n6l;
	Mon, 02 Feb 2026 17:39:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 6/6] trace-cmd documenatation: Update the trace.dat man page for BTF_FILE
Date: Mon,  2 Feb 2026 17:37:01 -0500
Message-ID: <20260202223941.2031858-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202223941.2031858-1-rostedt@goodmis.org>
References: <20260202223941.2031858-1-rostedt@goodmis.org>
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

