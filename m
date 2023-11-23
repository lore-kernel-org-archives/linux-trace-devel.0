Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258DB250E9;
	Thu, 23 Nov 2023 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0pEvxvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BDDC433C8;
	Thu, 23 Nov 2023 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700746829;
	bh=4/3MFKcSnNzFxXpwdTahwPqZj1DbgJoJ7bLgc5su8HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E0pEvxvwR7cPb6GEgqdMm3JUCtR3QEhvZZ62nN9kkwaFO0hoPEXeWh8O11XgxoUXC
	 LJNFXhV9g13IanBMELMe/9XENgNAYOkf/gWR1HCpN6yrW7QL0qAo0ytrJJnE+3JkLj
	 w2eO3eN4zLXCIT2HqPaYW+bGLkIgnyuCE6npWxS1d9iI5vAJkhoNDKZynfeejpoD7q
	 Am+/UYj9YEZiT6qesCZ+GSmA6/HAi8R8J+qKzYVodPag6MDfd/n5+nniihQ+jxWSPo
	 s69Llhy++rs+NdjnVyLssmEltR1eJ+tKpzf3MsiqCqFdIGArRRxhtle6MNXv0LFovx
	 y30es4PLZDpXg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
	id EDCD940094; Thu, 23 Nov 2023 10:40:25 -0300 (-03)
Date: Thu, 23 Nov 2023 10:40:25 -0300
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
Message-ID: <ZV9WSdshxv9MZTb0@kernel.org>
References: <20231110000012.3538610-1-namhyung@kernel.org>
 <20231110000012.3538610-19-namhyung@kernel.org>
 <ZVzvFen/214ylf32@kernel.org>
 <CAM9d7cijprv2fOM_jwYbrV0jbhno2ZQDCT3SExG=Ot=b2mANmw@mail.gmail.com>
 <ZV5cZe8dxv/GzdGa@kernel.org>
 <CAM9d7ci+rgyGmLmosNpA4Bk1u8sfwYCLVwN4grky5y4g2Weu3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM9d7ci+rgyGmLmosNpA4Bk1u8sfwYCLVwN4grky5y4g2Weu3g@mail.gmail.com>
X-Url: http://acmel.wordpress.com

Em Wed, Nov 22, 2023 at 01:13:04PM -0800, Namhyung Kim escreveu:
> On Wed, Nov 22, 2023 at 11:54 AM Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > Em Wed, Nov 22, 2023 at 10:49:13AM -0800, Namhyung Kim escreveu:
> > > On Tue, Nov 21, 2023 at 9:55 AM Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > > > ⬢[acme@toolbox perf-tools-next]$ perf report -s type
> > > > perf: Segmentation fault

> > > Right, the 'type' sort key was added here but unfortunately
> > > it's not ready for prime time yet.  It also needs the next patch
> > > 19/52 ("perf report: Support data type profiling") to fully enable
> > > the feature.  Do you think it's better to squash into here?

> > I haven't checked if squashing would be a good idea, but if you think
> > its the right granularity, then do it, as long as we can test features
> > in various ways as they are getting added, as I did, using a random
> > perf.data file.
 
> I still think it's better to split the change as it's logically separate.

The smaller the patches, the better, I'd say in general.

> But it's prematurely exposed then maybe needs some protection.

Yeah, that is what I felt like it needed, make it more robust by
checking if the used fields were properly initialized, etc.

- Arnaldo
