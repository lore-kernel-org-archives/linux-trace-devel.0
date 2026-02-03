Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2DF2877FE
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Feb 2026 23:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770161662; cv=none; b=fyQMnepYr/QUwYvoGuulGkvcYNKgcQiUbtpsqmfOaiepbU3vz4Fwvg2e/elLTYlS2iETt9K70suiejONxc5hLHokn2fhicTVGb/NYQLgFfHUTgtOyJDTaKLPiGsem0/TeFegrK0EynsLH8Arp6usolNVgV8ztrAkO1GzSx545fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770161662; c=relaxed/simple;
	bh=x3dZVB3GijHbZTUMjO1qUiSH73o+6M+Boi88UUgyrXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=teHUOE72o12aKtVYqQo9aJm2iESZ9P3oQJLKnHj8+kbFl4C9+QViX3JQKhSXWBdIjX1Tp8t4XkRYR1LMHwVUyM31Pe6melK04olZ30bWzTjP4cre1gbYk76L8pydoT27i9xVFUZy8Hg1+RNk9EnpD7+YAHdCgNra17ptPVhDXmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D7FC2BC87;
	Tue,  3 Feb 2026 23:34:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnPv2-00000008tFM-2Iyl;
	Tue, 03 Feb 2026 18:34:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 0/6] trace-cmd: Use BTF to show the arguments for function tracers
Date: Tue,  3 Feb 2026 18:32:23 -0500
Message-ID: <20260203233451.2118849-1-rostedt@goodmis.org>
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

Changes since v3: https://lore.kernel.org/all/20260202223941.2031858-1-rostedt@goodmis.org/

- Add "BTF" name to new section. It was currently NULL, and caused some issues
  with dumping the buffer.

Steven Rostedt (Google) (6):
  libtracecmd: Remove "compress" parameter from save_string_section()
  libtracecmd: Remove "compress" parameter from tcmd_out_compress*() functions
  libtracecmd: Add write_compress_section_header() for writing compress sections
  trace-cmd record / report: Record BTF file if function arguments are recorded
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

