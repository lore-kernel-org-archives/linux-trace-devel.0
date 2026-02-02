Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB712355034
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Feb 2026 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071958; cv=none; b=dIrsD9TCDBJj1FpoOcVcendg6hvHFWbg4xM7w5eb3jHXK10sUUf9ExEUD3URaGDrvvo4W0Svnxs9kfyQDveDZzuLbthS+K6lyHanJZDSOX/u2cSwP54Tq03xEmQ55ROSwdD+tCQW2fdknt/gJDTw/nS+OEmg5EknkGsgQf00oDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071958; c=relaxed/simple;
	bh=FM8/30K97WQRqBIQwQd12pCCq36UOFoGBcevEplGjzA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g2UCNC0rlDBKkpEarxn66i7Nb5Th/heYxqKmg8EE3DzgDEEOv9pEiRrmNWdBPItL2p3T8MCtDWJMoeCJvRUuiAUA5HjhsoLramDb49xLWYM3L4XI9L+AjK9Ri+XmUvOQpd/uvn0746rRZQlFiwcWgMy92oHd9Z3uVurSa5xEdY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBABC116C6;
	Mon,  2 Feb 2026 22:39:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vn2a8-00000008Wdu-31Qw;
	Mon, 02 Feb 2026 17:39:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 0/6] trace-cmd: Use BTF to show the arguments for function tracers
Date: Mon,  2 Feb 2026 17:36:55 -0500
Message-ID: <20260202223941.2031858-1-rostedt@goodmis.org>
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

Changes since v2: https://lore.kernel.org/all/20251114214959.470843-1-rostedt@goodmis.org

- Fixed tracecmd_append_btf_file() exiting out early when btf file doesn't
  exist. That would cause the offset to be incorrect and the next write to
  the trace.dat file would corrupt it. This happened with trace-cmd extract.

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

