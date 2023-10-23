Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF26B11CAC;
	Mon, 23 Oct 2023 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qDnpooZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1BBC433C7;
	Mon, 23 Oct 2023 16:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698079996;
	bh=TXIb9ClVcIo/XPCRnjO8NRpDlzzqasukBVOBLTc9BWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qDnpooZ2CYQ0HEv9N32JDu85BzOQLS/cGPttXUtDonzHulpUZ9Nlnkog4QZd2AAop
	 6sfclRflVDlfBY6Z028vXgOaCvgg6VMKj64Qgqt+SH57Hpgp/J2RFQqkWyLgZ9ikPL
	 iEjyPk+TzLh7/AQ0TK63JDRkHGZh9PByT84rcjPS+DzLa0dzIEwJBjOfoqkV9jgUjc
	 e0sxFGUitX2B04NGPKVcAJ1uSc9Cbm9qQmcUEy2McenTeGs57DjGaVyewDpTbq7ZUQ
	 xiR50xeMq713SHG2QUFWHmq4TG6s7puBYqhJGVA9ZjMltdQoiAehiujrsgdHiZCMdS
	 KHTo6sLj4Z5uQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
	id 67A9D4035D; Mon, 23 Oct 2023 13:53:13 -0300 (-03)
Date: Mon, 23 Oct 2023 13:53:13 -0300
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
Subject: Re: [PATCH 15/48] perf report: Add 'type' sort key
Message-ID: <ZTak+X5ZzkBr6s9P@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
 <20231012035111.676789-16-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012035111.676789-16-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com

Em Wed, Oct 11, 2023 at 08:50:38PM -0700, Namhyung Kim escreveu:
> The 'type' sort key is to aggregate hist entries by data type they
> access.  Add mem_type field to hist_entry struct to save the type.
> If hist_entry__get_data_type() returns NULL, it'd use the
> 'unknown_type' instance.

Needed the patch below, doing the same that is a bit before for
libtraceevent

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index c79564c1d5df5db3..3fae226d115ef8e6 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2132,6 +2132,7 @@ struct sort_entry sort_addr = {
 	.se_width_idx	= HISTC_ADDR,
 };
 
+#ifdef HAVE_DWARF_SUPPORT
 /* --sort type */
 
 static int64_t
@@ -2190,7 +2191,7 @@ struct sort_entry sort_type = {
 	.se_snprintf	= hist_entry__type_snprintf,
 	.se_width_idx	= HISTC_TYPE,
 };
-
+#endif // HAVE_DWARF_SUPPORT
 
 struct sort_dimension {
 	const char		*name;
@@ -2246,7 +2247,9 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_LOCAL_RETIRE_LAT, "local_retire_lat", sort_local_p_stage_cyc),
 	DIM(SORT_GLOBAL_RETIRE_LAT, "retire_lat", sort_global_p_stage_cyc),
 	DIM(SORT_SIMD, "simd", sort_simd),
+#ifdef HAVE_DWARF_SUPPORT
 	DIM(SORT_ANNOTATE_DATA_TYPE, "type", sort_type),
+#endif
 };
 
 #undef DIM
