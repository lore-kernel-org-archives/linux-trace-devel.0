Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C425817FC;
	Wed, 25 Oct 2023 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Amw346gw"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF65C10C6;
	Tue, 24 Oct 2023 19:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698199768; x=1729735768;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tM33/slKrB++OIadj/NigLF45+0D5ztylCW7LoOSFx8=;
  b=Amw346gwBAWcmqbMD3zFFxRfXzzNWx/+HAnvQ3X8P7nziwwRuTAIfrjf
   TnIkwWvSxBKyjUfZy/3ZWuv17NosarJ9dE4Fx/nf/k48jmxTzrXmRr2Ce
   IQti6KsorWdEuP/k3ZhoOIc7/5XKGX8+WJgXwaMIH642mf4eKDeHxlD36
   p1lK7EqgWoKsscHm8I+VbzcubhBhFNq4x3lUXMEXcFifDxwYg2Y2kKgSR
   25CFfw7sPIv/0voqZ/TY75SN+YG0wYc+2H7QxpBG3/JxEDrxlheOwcGvK
   t/Hz1ZNqexgdq3nkyIlzj+0nwS9hGejybqTUaJdR6u8ZXbbofuUIGgcI+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="367433559"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="367433559"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 19:09:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="1005841775"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="1005841775"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 19:09:26 -0700
Date: Tue, 24 Oct 2023 19:09:25 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stephane Eranian <eranian@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-toolchains@vger.kernel.org, linux-trace-devel@vger.kernel.org,
	Ben Woodard <woodard@redhat.com>, Joe Mario <jmario@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	David Blaikie <blaikie@google.com>, Xu Liu <xliuprof@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [RFC 00/48] perf tools: Introduce data type profiling (v1)
Message-ID: <ZTh41epbjwGsMPaB@tassilo>
References: <20231012035111.676789-1-namhyung@kernel.org>
 <87pm15vw5r.fsf@linux.intel.com>
 <CAM9d7ch504cnFzTL1qPh349uSrbEZop19kB-DbUsnoOKEvtFBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7ch504cnFzTL1qPh349uSrbEZop19kB-DbUsnoOKEvtFBQ@mail.gmail.com>

> 
> >
> > The main difference seems to be that mine was more for perf script
> > (e.g. i supported PT decoding), while you are more focused on sampling.
> > I relied on the kprobes/uprobes engine, which unfortunately was always
> > quite slow and had many limitations.
> 
> Right, I think dealing with regular samples would be more useful.

My code supported samples too, but only through perf script, not report.

See 

https://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git/commit/?h=perf/var-resolve-7&id=4775664750a6296acb732b7adfa224c6a06a126f

for an example.

My take was that i wasn't sure that perf report is the right interface
to visualize the variables changing -- to be really usable you probably
need some plots and likely something like an UI.

For you I think you focus more on the types than the individual
variables? That's a slightly different approach.

But then my engine had a lot of limitations, i suppose redoing that on
top of yours would give better results.


-Andi
