Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A3415EBA
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Oct 2023 14:57:04 +0000 (UTC)
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E0BFC
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Oct 2023 07:56:59 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-352a22e1471so6272885ab.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Oct 2023 07:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696431418; x=1697036218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QW9FPFU+6L2qsnOmrnj4oO7zLWeGbQvKXR0HTaJF9zE=;
        b=Zxfdi9rtz6WWm1iJUx8Pxde6VEfE9JcGbJkNr88a0UOSVTcGlMz68b2k5oBXBB+mt8
         Z/NrBvK44Icm+MkH8h8SSdO2UhLSPP9QpMYa4nhO1JdURgniX67BD8YLug1kkhZ+fGH3
         23pqjgNuhfmA31tAfo7cD3gXfB1i+RLd+cxr3RM6FoI+nbixif7k7T2A2vjIY9KFrW3b
         iOPtB53JpHBp9X+/QtAqXMnDTlSkx1LPKvjJ34Y9QWk75FTsvLrl1vWlDWGgQKhaiXjv
         nnNlJU3W/u9OJ5NiMah8mldjQxEpXuCvCT3+XpQ9YQvKngSlQhmMMaDKtYAzTtSJOt8S
         gQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696431418; x=1697036218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QW9FPFU+6L2qsnOmrnj4oO7zLWeGbQvKXR0HTaJF9zE=;
        b=NaNOyhD3Qm4DhGTXqLlEZGUDFG5QCq3izziG5/WpdDyDN1xkORKmXdx2Mdca1dIdNw
         gp8UYxFt9vudWOthUN+RZNwwzi0fKGx1UUYtAPGpp7wAL7kzCGOSoxuaYfAjYVskogB4
         9zwcv1qfyTOMmMEZ49Zhjb0+gtT4It0dnDB/E9gB2Gt2aY6d3vWNTmsDQ3grc0dwY4Mh
         6YkX7yV1t/VbSf3S4zc37kMJWLFeuGKfKKP1E6w2H004QzitTBErmEtGsJKXQksmZNKY
         d75LJRllZuIisD72SaikJUIDy4PAf3MgoYo86O44aw3iVOGCAacZGwP1fqvBa2DV9CV9
         sPpQ==
X-Gm-Message-State: AOJu0YwG1M42hD968i+cmUIAsQdV3ivqXJiR0R0oewgo2HOZq4KLxsoF
	xzfjJiRpZwox8LJDMJlNV4YJ4g==
X-Google-Smtp-Source: AGHT+IFbhlE00yGYMXobGBIP/OZYgQP596VErf2VY61hfsz4dBIqXtlWjqdd0DNJHLBOsZDQ1AB1JA==
X-Received: by 2002:a05:6e02:d03:b0:351:5a77:f169 with SMTP id g3-20020a056e020d0300b003515a77f169mr2328556ilj.29.1696431418036;
        Wed, 04 Oct 2023 07:56:58 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:d5ff:6f50:bbbd:a922])
        by smtp.gmail.com with ESMTPSA id y11-20020a92c74b000000b003513535c69dsm1037885ilp.5.2023.10.04.07.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 07:56:57 -0700 (PDT)
Date: Wed, 4 Oct 2023 08:56:54 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtraceeval: Use name for type look up for
 traceeval_stat
Message-ID: <20231004145654.GA2510728@google.com>
References: <20231003181237.616cc8db@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003181237.616cc8db@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Oct 03, 2023 at 06:12:37PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The functions that retrieve the traceeval_stat currently requires passing
> in the struct traceeval_type. But this is fragile, as it may not be set up
> properly. It was originally done that way as a "fast" way to look up
> stats, but in reality it will likely just cause more issues with wrong
> types passed in. That decision was based more on defining policy which the
> library should not do.
> 
> Instead, just pass in the string name of the value type to find and
> retrieve the traceeval_data value from the traceeval that way.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval.h |  4 ++--
>  src/histograms.c    | 39 ++++++++++++++++++++++++++++++---------
>  2 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/include/traceeval.h b/include/traceeval.h
> index 48c28dfc2f99..32996ba17e5f 100644
> --- a/include/traceeval.h
> +++ b/include/traceeval.h
> @@ -219,7 +219,7 @@ size_t traceeval_count(struct traceeval *teval);
>  struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
>  					   const struct traceeval_data *keys,
>  					   size_t nr_keys,
> -					   struct traceeval_type *type);
> +					   const char *val_name);

Probably need to also s/type/val_name/g for the traceeval_stat() macro so they
stay in sync, and need to update the calls to traceeval_iterator_stat() and
traceeval_stat() in samples/task-eval.c so they continue to work.
