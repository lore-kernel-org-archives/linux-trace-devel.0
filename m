Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBFD4F5F6;
	Wed, 22 Nov 2023 19:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrNG99+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786A1C433C7;
	Wed, 22 Nov 2023 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700682856;
	bh=zRXHgQP88VauegiSbHXFvskpTZuZ3/Jyf1lcUiA8WAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mrNG99+mNALbVJhcW1vZYsOwvFPrCrTvA/jh7hRpd+LcpAjrWl05+dsKNccSbPsQl
	 CLw7RDjB0YX0WiVhHbqf4bY9sED1Rdv/BrMc8ZrGKZ5/BLGHHvd20AZO2c0TAHDJ8/
	 UIEsJBiFfOmx7vSiQzWUEMb1af9hnvTsLwmFPMzoJZVyDpEAz00YfkUslW/9lK6sx+
	 w1utbiS0AeRY7ZD+z8iRjs28Gdo/91ZkODeVDhByD7rdvYxm4uzW1S1FJxUq9i27h1
	 GY17Su7N4FztAwiZgXMRDkO+eDd7QrVLu3b9aC4GNwIsYnFVZUOWHLbkaF/UDnTO2G
	 8WLRqznC+zHrw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
	id 71AA640094; Wed, 22 Nov 2023 16:54:13 -0300 (-03)
Date: Wed, 22 Nov 2023 16:54:13 -0300
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
	Andi Kleen <ak@linux.intel.com>, linux-trace-devel@vger.kernel.org,
	linux-toolchains@vger.kernel.org
Subject: Re: [PATCH 18/52] perf report: Add 'type' sort key
Message-ID: <ZV5cZe8dxv/GzdGa@kernel.org>
References: <20231110000012.3538610-1-namhyung@kernel.org>
 <20231110000012.3538610-19-namhyung@kernel.org>
 <ZVzvFen/214ylf32@kernel.org>
 <CAM9d7cijprv2fOM_jwYbrV0jbhno2ZQDCT3SExG=Ot=b2mANmw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM9d7cijprv2fOM_jwYbrV0jbhno2ZQDCT3SExG=Ot=b2mANmw@mail.gmail.com>
X-Url: http://acmel.wordpress.com

Em Wed, Nov 22, 2023 at 10:49:13AM -0800, Namhyung Kim escreveu:
> On Tue, Nov 21, 2023 at 9:55 AM Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > ⬢[acme@toolbox perf-tools-next]$ perf report -s type
> > perf: Segmentation fault
> > -------- backtrace --------
> > perf[0x69f743]
> > /lib64/libc.so.6(+0x3dbb0)[0x7f89b4778bb0]
> > perf[0x505af6]
<SNIP>
> > perf[0x504f01]
> > /lib64/libc.so.6(+0x27b8a)[0x7f89b4762b8a]
> > /lib64/libc.so.6(__libc_start_main+0x8b)[0x7f89b4762c4b]
> > perf[0x40ed65]
> > ⬢[acme@toolbox perf-tools-next]$
>
> Right, the 'type' sort key was added here but unfortunately
> it's not ready for prime time yet.  It also needs the next patch
> 19/52 ("perf report: Support data type profiling") to fully enable
> the feature.  Do you think it's better to squash into here?

I haven't checked if squashing would be a good idea, but if you think
its the right granularity, then do it, as long as we can test features
in various ways as they are getting added, as I did, using a random
perf.data file.

- Arnaldo
