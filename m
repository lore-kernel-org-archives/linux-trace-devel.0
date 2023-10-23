Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9787421340;
	Mon, 23 Oct 2023 17:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PynV0iN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43E8C433CC;
	Mon, 23 Oct 2023 17:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698082860;
	bh=s4PKCMf+mYuSUwyiknZuLzVRYAXpdi2OJwb++cxkFEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PynV0iN4icEZwIhXh70iTiOLjBEUrQgryyDXXlM+tU3CX9N1FACwjCvT2WP+yuFGu
	 j02ZCdlLP5FMs5/pM6IAmRx1eBwpIHHRjGILuM15bVM8UHBThh4Fx5l5pCzr9m/IqY
	 /AoosjqM0s3Tg3M9m1no734HSQoWqd0fs8oxF4oJI6lmI+8yggG8eCC5FWGKTKFraw
	 wj3JJl6uaiCad+He5ZFMI0b9X+TIVt3O3aaS2sZy/KsLAkxaph2TEqg9wJkn5UjixR
	 4BhDQ1AdiV06mnf88EBW8g5m0zwkbKIWTa8+dbsAJQKH/aMAZaeIhmVw9l2jFuRFUy
	 iBMOPDDrndtsg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
	id 5CCB64035D; Mon, 23 Oct 2023 14:40:57 -0300 (-03)
Date: Mon, 23 Oct 2023 14:40:57 -0300
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
Subject: Re: [PATCH 22/48] perf annotate: Add --type-stat option for debugging
Message-ID: <ZTawKZK/ImWsPkUI@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
 <20231012035111.676789-23-namhyung@kernel.org>
 <ZTatKUD6nS7OlvuC@kernel.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTatKUD6nS7OlvuC@kernel.org>
X-Url: http://acmel.wordpress.com

Em Mon, Oct 23, 2023 at 02:28:10PM -0300, Arnaldo Carvalho de Melo escreveu:
> When building with NO_DWARF=1 or in systems lacking the used DWARF
> libraries. I noticed with some of the build containers, will updated
> those to have the required libraries so that this feature gets compile
> tested there.

The problem was that I build with/without NO_LIBELF=1, and with it set
NO_DWARF=1 is enabled and thus breaks the build.

- Arnaldo
