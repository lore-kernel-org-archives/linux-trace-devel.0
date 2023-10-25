Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CB3328C0;
	Wed, 25 Oct 2023 20:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KdrfpdGK"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D04183;
	Wed, 25 Oct 2023 13:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698264202; x=1729800202;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=YLZGgBkznfjPx0x7i1mnmcfOOiepLxrJSAVTpEABg3I=;
  b=KdrfpdGKHZzii6dq6/Njstq5GoQlhBH3oJQZrwmL9AP5KtqjEwYc9f/w
   S75sMxRCMuUeoX+aToXqz4jFdf641drwhyTlaNFhxax/tOWJWXV8WEazp
   gn1PIjdFvRT4xLLLFToJPOJ3zpgQtL32mDN6h98sN+W8O9TZscy5vKomc
   kxx1Xqllgm2qCitCFcNt4ntzBHjd8LNSONVB4VSPDSCR8T8ZT4r3qKD+e
   kjqzaNmwVcnt4rTjtW6aOvNYgPe7Y+mCyi58LHdA/H1XeFPgPEpurUT4y
   lnC0W5ketLiAvQkZJC3sdJ2T0FtbBWK10QbTxg7gluo+KL+HmcRw3Ziu6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="473624936"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="473624936"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 13:01:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="902664878"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="902664878"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 12:59:31 -0700
Date: Wed, 25 Oct 2023 13:01:53 -0700
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
Message-ID: <ZTl0MdKauLd21ahn@tassilo>
References: <20231012035111.676789-1-namhyung@kernel.org>
 <87pm15vw5r.fsf@linux.intel.com>
 <CAM9d7ch504cnFzTL1qPh349uSrbEZop19kB-DbUsnoOKEvtFBQ@mail.gmail.com>
 <ZTh41epbjwGsMPaB@tassilo>
 <CAM9d7cgin9=dh-cypSzpvfZu_N7qv8Gxg0VVGdOm+VXB8i1FAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM9d7cgin9=dh-cypSzpvfZu_N7qv8Gxg0VVGdOm+VXB8i1FAQ@mail.gmail.com>

On Tue, Oct 24, 2023 at 10:51:41PM -0700, Namhyung Kim wrote:
> On Tue, Oct 24, 2023 at 7:09 PM Andi Kleen <ak@linux.intel.com> wrote:
> >
> > >
> > > >
> > > > The main difference seems to be that mine was more for perf script
> > > > (e.g. i supported PT decoding), while you are more focused on sampling.
> > > > I relied on the kprobes/uprobes engine, which unfortunately was always
> > > > quite slow and had many limitations.
> > >
> > > Right, I think dealing with regular samples would be more useful.
> >
> > My code supported samples too, but only through perf script, not report.
> >
> > See
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git/commit/?h=perf/var-resolve-7&id=4775664750a6296acb732b7adfa224c6a06a126f
> >
> > for an example.
> >
> > My take was that i wasn't sure that perf report is the right interface
> > to visualize the variables changing -- to be really usable you probably
> > need some plots and likely something like an UI.
> 
> I see.  Your concern is to see how variables are changing.
> But it seems you only displayed constant values.

Yes the examples were not very good, but that was the intention.
Values can be much more powerful than only types!

For PT I also had special compiler patch that added suitable ptwrites
(see [1]) that allowed to track any variable.

-Andi

[1] https://github.com/andikleen/gcc-old-svn/tree/ptwrite-18
