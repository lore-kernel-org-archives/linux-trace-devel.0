Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE26C1CA9C;
	Mon, 23 Oct 2023 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMQB6N3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FE5C433C8;
	Mon, 23 Oct 2023 16:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698079083;
	bh=PmOhABY1//m3uavFWKiIgtRvu0OAYB3NtnB3wb/zXec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MMQB6N3We8yFL61X4/+4r1DmfCP5DVsh4WUc1JRt14fBnvyxBucsSjWuVYlGHk5PU
	 OHx0RUYcwov1cWggrLP7+agpgmMKqwqIsbN/1jETwdwdgPCsrgx5k74/Dbr+agyq8H
	 RRHE70vUXdgkPcFsWZIgeIWuoaEU2D8oC7dW4hWPStU3EIbQGzLlBjKROBl0pk6Ttv
	 xAVIyExIW0tXvWzqej4JppEE4IL8W846Fa7nQ+KaHuZ5Z2SjkWZt0TaqmJZN6ynav7
	 JhO5LnljaLZ07568GEGw5U/tpxe/n2zNIrxm/PeaK8cl7Xk8CzThQqiHy0z4Veoda4
	 9b2ow8ltNlPYg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
	id 717D44035D; Mon, 23 Oct 2023 13:38:00 -0300 (-03)
Date: Mon, 23 Oct 2023 13:38:00 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stephane Eranian <eranian@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-toolchains@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 13/48] perf annotate: Add annotate_get_insn_location()
Message-ID: <ZTahaOOOgFkclARB@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
 <20231012035111.676789-14-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012035111.676789-14-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com

Em Wed, Oct 11, 2023 at 08:50:36PM -0700, Namhyung Kim escreveu:
> The annotate_get_insn_location() is to get the detailed information of
> instruction locations like registers and offset.  It has source and
> target operands locations in an array.  Each operand can have a
> register and an offset.  The offset is meaningful when mem_ref flag is
> set.

This needs to be enclosed in HAVE_DWARF_SUPPORT, as the build is failing
in systems where this isn't available, see patch below.

  CC      /tmp/build/perf/arch/x86/util/pmu.o
util/annotate.c: In function 'extract_reg_offset':
util/annotate.c:3537:24: error: implicit declaration of function 'get_dwarf_regnum' [-Werror=implicit-function-declaration]
 3537 |         op_loc->reg1 = get_dwarf_regnum(regname, 0);
      |                        ^~~~~~~~~~~~~~~~
  CC      /tmp/build/perf/tests/vmlinux-kallsyms.o

I tested it with 'make NO_DWARF=1'

- Arnaldo

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 9d653a1e84ce4889..b998c81c89be04fc 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -3486,6 +3486,7 @@ int annotate_check_args(struct annotation_options *args)
 	return 0;
 }
 
+#ifdef HAVE_DWARF_SUPPORT
 /*
  * Get register number and access offset from the given instruction.
  * It assumes AT&T x86 asm format like OFFSET(REG).  Maybe it needs
@@ -3591,3 +3592,4 @@ int annotate_get_insn_location(struct arch *arch, struct disasm_line *dl,
 
 	return 0;
 }
+#endif // HAVE_DWARF_SUPPORT
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 4adda492233d2742..484be346a279c481 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -437,6 +437,7 @@ int annotate_parse_percent_type(const struct option *opt, const char *_str,
 
 int annotate_check_args(struct annotation_options *args);
 
+#ifdef HAVE_DWARF_SUPPORT
 /**
  * struct annotated_op_loc - Location info of instruction operand
  * @reg: Register in the operand
@@ -473,4 +474,5 @@ struct annotated_insn_loc {
 int annotate_get_insn_location(struct arch *arch, struct disasm_line *dl,
 			       struct annotated_insn_loc *loc);
 
+#endif /* HAVE_DWARF_SUPPORT */
 #endif	/* __PERF_ANNOTATE_H */
