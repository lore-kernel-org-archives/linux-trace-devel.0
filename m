Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20993E560
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:40:26 +0000 (UTC)
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7899BBF
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:40:24 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-3515aad4a87so624345ab.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696279224; x=1696884024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MI8wkNlUnW733bm8ZaABvkPtd4pydrlihBsamaQLbZ0=;
        b=WenF0CSMrprRB2HQBiuafWB6hjnxozynl6h74dM3pEFDkRPCVXXhjxTjmJl0OZ9FTE
         6b8xN5FmI4etccTgFTadP86QVNG0NlaOD/mckwov7r2RKlMaBDlvW2I02wdThRrETbyP
         MPhVxMDJDmR9YqgsUY/Ey5S3IFcIi9lhVCxkqMpUhV9rBkqkua91QCAFaklYRVJR4UOo
         UEjromRwWfUMgEE6cHhqp5mVrShVJmC1Py85fBzZ2AmHw+h2DOGIkoANvn2xxshT6zLY
         +1EO8pPfYyyzpfTNBUCuE6yD7VdE9eBYuJhRY+jp1zP9tqA0uUgFbQhOe+fpWP4Vz9Tp
         URyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696279224; x=1696884024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MI8wkNlUnW733bm8ZaABvkPtd4pydrlihBsamaQLbZ0=;
        b=wjEd173uwFABjxuHQbY0XAUi1PqVZhgs9j4NaDxAgA0Qm6H6fGyL4oMH5Ha2xi4tFD
         jNO22ONadamg1mRBpcsPt21KCMzV8T2GkqSUP+iqC2Sagexl9+8Gvs/OCk5Vx2s0FtiK
         B8DRMFgGPiKL6cwx64BXZj06l3lMo21zAoGVsBV8G/Qx6JcmISRt/idkOrKWbIDCSbv9
         lf4CunW0x2BGBstp+5vGQHphhtLn6w673TGHTXnTN/xRij/YjcwKGvf/ewVNvrda7Cs3
         Byz6Ox7UQ+NwbBaCaoBcFO015eIsOpXsOW8GuLxS+qu0bjq18GYCLyfK+ESlVm2tOwYx
         brZQ==
X-Gm-Message-State: AOJu0YzeaQOT8GxfZ7WBuBca39eTbtPBT/tHLUnsQEU0Qt9NeoJBc1t2
	IYDoiC43bevURyyWfykfeAca3s00AnDVdOkn7A69wg==
X-Google-Smtp-Source: AGHT+IGdyM0p5ikZmSxRRT8aL4ZjirvJlNzJPe4s1p0vJvCwNRsR6CUACa3vHjq2Qa9k9vbNjm6seg==
X-Received: by 2002:a05:6e02:b4f:b0:351:e6e:7723 with SMTP id f15-20020a056e020b4f00b003510e6e7723mr15697725ilu.25.1696279223671;
        Mon, 02 Oct 2023 13:40:23 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id g6-20020a02c546000000b004290f6c15bfsm7123142jaj.145.2023.10.02.13.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 13:40:23 -0700 (PDT)
Date: Mon, 2 Oct 2023 14:40:19 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Ross Zwisler <zwisler@chromium.org>
Subject: Re: [PATCH] traceeval: Add way to extract the number of elements
Message-ID: <20231002204019.GK1532181@google.com>
References: <20230928102434.58e08f78@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928102434.58e08f78@rorschach.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Sep 28, 2023 at 10:24:34AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add traceeval_count() that will return the number of elements in the
> traceeval. This can be useful for allocating an array to store the
> elements. By getting the count, the allocation can be done first and
> then iterated to load the elements into the array.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |  2 ++
>  src/histograms.c         | 11 +++++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index eefa48d..44d071f 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -204,6 +204,8 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
>  void traceeval_results_release(struct traceeval *teval,
>  			       const struct traceeval_data *results);
>  
> +size_t traceeval_count(struct traceeval *teval);
> +
>  #define traceeval_stat(teval, keys, type)				\
>  	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), type)
>  
> diff --git a/src/histograms.c b/src/histograms.c
> index 2456342..ac3f7f7 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -1006,6 +1006,17 @@ int traceeval_remove_size(struct traceeval *teval,
>  	return 1;
>  }
>  
> +/**
> + * traceeval_count - Return the number of elements in the traceeval
> + * @teval: The traceeval handle to get the count from
> + *
> + * Returns the number of elements stored by unique keys in the @teval.
> + */
> +size_t traceeval_count(struct traceeval *teval)
> +{
> +	return teval->update_counter;

I don't think this is going to do what you want.  'teval->update_counter'
is a generation number, is monotonically increasing, and is incremented any
time an element is added or removed from the hash.

I think we either need to actually keep an element count (increment in
create_entry(), decrement in traceeval_remove_size() and
traceeval_iterator_remove()), or else we're going to have to count the
elements by walking the 'struct hash_table' buckets.  Probably easier to just
keep an explicit element count.

> +}
> +
>  /**
>   * traceeval_iterator_put - release a given iterator
>   * @iter: The iterartor to release
> -- 
> 2.40.1
> 
