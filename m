Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F30218659;
	Tue, 24 Oct 2023 19:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7AF10C6;
	Tue, 24 Oct 2023 12:11:58 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5aa7fdd1420so2883474a12.3;
        Tue, 24 Oct 2023 12:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698174718; x=1698779518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0oWWL0uRZSylfCBA5EKpsd4B0UiMiOChwDu1lsgUGs4=;
        b=UGBiKSp6wh7H4c3scy7XwGlzzdpZh9/61+dKNZlC9D1CmuQKuc18ORVWkpUyeub7hd
         XyVN6bbB9u+D2kYWYFT3gEv9aN5FTgJQEM5B+HdG/fYLyyZWgErSjCpy8OryFzhJU8hg
         rvCDtMtmvPltn9pR5J8B+iPyPhOV4JvUZNljXIjN/jf5mqaFXp09KVewnC1culImz/VF
         BChK0zkz4V4dykgmLQd6krbXAQKX9advrsElODvyQ+Ctlv50++TVE80eu6l66EDXtjk/
         MkSvJjwcycakNaiYPGmrqyaGCqTc/P4jdrtTRSO6pIxvIfVssNpTr6qoAiVfw1NxCmxY
         MytA==
X-Gm-Message-State: AOJu0Yx6VBULENsJ1B/y2pY5hoqyrrtHnZV4J2I0TLtmAk7KQ/25Lo7G
	lbXT/hoNCnHLp5ONYloWKwt0TLzZlyoqZdrfmWA=
X-Google-Smtp-Source: AGHT+IFDNEfdxo3lcG4zWt1cqxolXI84Im4nhIgzqullRuXSNylr0FOkr1NXf2kkUL3JEYEjJ9bNDcbwNnc0Z98Itaw=
X-Received: by 2002:a17:90a:19cb:b0:27d:5f1f:8eed with SMTP id
 11-20020a17090a19cb00b0027d5f1f8eedmr10021354pjj.14.1698174718081; Tue, 24
 Oct 2023 12:11:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <20231012035111.676789-16-namhyung@kernel.org>
 <ZTak+X5ZzkBr6s9P@kernel.org>
In-Reply-To: <ZTak+X5ZzkBr6s9P@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 24 Oct 2023 12:11:46 -0700
Message-ID: <CAM9d7cj8WnHQT-QVdd4ck0jtTC5iXws9u4dWFuR45vwTMTtVEw@mail.gmail.com>
Subject: Re: [PATCH 15/48] perf report: Add 'type' sort key
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-perf-users@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org, 
	linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 9:53=E2=80=AFAM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Wed, Oct 11, 2023 at 08:50:38PM -0700, Namhyung Kim escreveu:
> > The 'type' sort key is to aggregate hist entries by data type they
> > access.  Add mem_type field to hist_entry struct to save the type.
> > If hist_entry__get_data_type() returns NULL, it'd use the
> > 'unknown_type' instance.
>
> Needed the patch below, doing the same that is a bit before for
> libtraceevent

I think it can always return unknown_type if libtraceevent is not
enabled.  Maybe I need to move the definition here then.

Thanks,
Namhyung

>
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index c79564c1d5df5db3..3fae226d115ef8e6 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -2132,6 +2132,7 @@ struct sort_entry sort_addr =3D {
>         .se_width_idx   =3D HISTC_ADDR,
>  };
>
> +#ifdef HAVE_DWARF_SUPPORT
>  /* --sort type */
>
>  static int64_t
> @@ -2190,7 +2191,7 @@ struct sort_entry sort_type =3D {
>         .se_snprintf    =3D hist_entry__type_snprintf,
>         .se_width_idx   =3D HISTC_TYPE,
>  };
> -
> +#endif // HAVE_DWARF_SUPPORT
>
>  struct sort_dimension {
>         const char              *name;
> @@ -2246,7 +2247,9 @@ static struct sort_dimension common_sort_dimensions=
[] =3D {
>         DIM(SORT_LOCAL_RETIRE_LAT, "local_retire_lat", sort_local_p_stage=
_cyc),
>         DIM(SORT_GLOBAL_RETIRE_LAT, "retire_lat", sort_global_p_stage_cyc=
),
>         DIM(SORT_SIMD, "simd", sort_simd),
> +#ifdef HAVE_DWARF_SUPPORT
>         DIM(SORT_ANNOTATE_DATA_TYPE, "type", sort_type),
> +#endif
>  };
>
>  #undef DIM
