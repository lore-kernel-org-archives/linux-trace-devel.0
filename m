Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3346418021;
	Fri, 10 Nov 2023 12:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLMpGod3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6EDC433C8;
	Fri, 10 Nov 2023 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699617950;
	bh=FANwVyHHNldSGNrf6smnb0g9+z/X47XttStGkOaEAyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bLMpGod3aUldA/oNpy3DazniO6/HK2kkZkqO4tSS3O0hFl/UWrpwkqFC1RjRbev8l
	 iKZNmJv1z7vyYcEghIHFlQK9KTJFg0SlKBkXYNeCKFHuDFv+NBAjLnHAfScEESUXxy
	 MgB7aYkSSM92WAWw8yhspankNQyZ5QNUxaWPnxlJ7sQNqkT0+y6HHu5IDrk2EstkAw
	 HM84Fv6nAZc74Hl7+p+CVeeh+chLcrmh2BZhdjsCntwHkDtkh02CPrIqfAhMWTJmTQ
	 NhuzWLpMnFiZYe0kJ1UBLZgqmfgEBhJaWHeRUKFjPSlYpKVNArhsMscdA+Tct5qj6J
	 mvuZPItx8+zmQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
	id 9CB2F40094; Fri, 10 Nov 2023 09:05:47 -0300 (-03)
Date: Fri, 10 Nov 2023 09:05:47 -0300
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
	linux-toolchains@vger.kernel.org, Ben Woodard <woodard@redhat.com>,
	Joe Mario <jmario@redhat.com>, Kees Cook <keescook@chromium.org>,
	David Blaikie <blaikie@google.com>, Xu Liu <xliuprof@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Mark Wielaard <mark@klomp.org>, Jason Merrill <jason@redhat.com>
Subject: Re: [RFC 00/52] perf tools: Introduce data type profiling (v2)
Message-ID: <ZU4cmwfQSK5wXbAD@kernel.org>
References: <20231110000012.3538610-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110000012.3538610-1-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com

Em Thu, Nov 09, 2023 at 03:59:19PM -0800, Namhyung Kim escreveu:
> * Patch structure
> 
> The patch 1-5 are cleanups and a fix that can be applied separately.

Applied so far 1-9, will continue later.

- Arnaldo
