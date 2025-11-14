Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538551BD9CE
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Nov 2025 21:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156982; cv=none; b=Hpp9XjUhdiSBDibYltoa4TwrWtlwGHyfosjHcToV/6gXWbJnDDI3BbPbSyWwzfpZWV6sL3el9c9dc7y1Br8JBD135Jliyzmrv9XHzCvP/DYHbZsBztcD/mWVqD6otKZcxn8EnVNm5WvDqJSEYBSqmukjY61bamgQi0qXctCK7NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156982; c=relaxed/simple;
	bh=OCHXS+S7XKnwLVWLbAvAqW/plaPHXGs1/9BeOmEG5bw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EooD9XhqfAl1wl0/k2FqcSF3YIurYT53t1aPaFA3qsdqj5i7qZInB+cNbi01g95PFhAM7fg4N/PbjvPIoJOvf3jdX6pbDcilFJBil8BkLjIopA+hpeqEhB7MWvO24jOPx/TC6B7lfmW+sjSdraHrtJIJj7Q/2v7Xg+lxNuvA6Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288FEC2BC86;
	Fri, 14 Nov 2025 21:49:42 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vK1g8-00000001yWU-3OON;
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
Subject: [PATCH v2 0/6] trace-cmd: Use BTF to show the arguments for function tracers
Date: Fri, 14 Nov 2025 16:47:26 -0500
Message-ID: <20251114214959.470843-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have trace-cmd use the new BTF parsing to show the arguments of function
tracing.

Changes since v1: https://lore.kernel.org/all/20250731202238.1654368-5-rostedt@goodmis.org/

- Cleaned up the compression code

- Have this still compile if libtraceevent doesn't have the BTF code (coming
  in libtraceevent v1.9).

- Have it work with function graph tracer too

- Updated the trace.dat man page


Steven Rostedt (Google) (6):
  libtracecmd: Remove "compress" parameter from save_string_section()
  libtracecmd: Remove "compress" parameter from tcmd_out_compress*()
    functions
  libtracecmd: Add write_compress_section_header() for writing compress
    sections
  trace-cmd record / report: Record BTF file if function arguments are
    recorded
  libtracecmd: Add printing of arguments for function graph tracer
  trace-cmd documenatation: Update the trace.dat man page for BTF_FILE

 .../trace-cmd/trace-cmd.dat.v7.5.txt          |  19 ++
 Makefile                                      |   9 +
 .../include/private/trace-cmd-private.h       |   3 +
 lib/trace-cmd/include/trace-cmd-local.h       |   7 +-
 lib/trace-cmd/trace-compress.c                |  26 ++
 lib/trace-cmd/trace-ftrace.c                  |  58 ++++-
 lib/trace-cmd/trace-input.c                   |  68 ++++--
 lib/trace-cmd/trace-output.c                  | 228 ++++++++++--------
 meson.build                                   |   3 +
 tracecmd/trace-record.c                       |  42 +++-
 10 files changed, 330 insertions(+), 133 deletions(-)

-- 
2.51.0

