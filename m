Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CB71EA90
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 18:31:14 +0000 (UTC)
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94082AD
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 11:31:12 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-3512efed950so152675ab.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 11:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696271472; x=1696876272; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=++pTUHyu/u7nbHx5/OgPMJ8ogjZFrTzCf1ydldSFYNQ=;
        b=X14Gc1hRpXvsA7BIPHVsOstF9FGSZA2TOniaW1dh9uUDrdufoz5vI5ebz3mfw50gC/
         6xb9cM9JYlOf4612ZJlKTt9eT2P7MdAS9KHi7PYryOfzH1fuxTO0nXy6d/hey60Y4d0f
         cTX1yD4hTzNHn2rPo2tdKLQPzxOuZso5Fl9k8e/fJtDXvlQI9mTBNJxLXv2azWVAOV7D
         gCYBdBBltBYR4kIwN4pWyUsruOxiyiEkZYL7pnqX0JGLQg29OoY4xeGTFRcL+NroM6dR
         9ONIYMvCfLIyi6jo9Q74xpJen1G/Svr1UNiax1M4H5QKtOtjfS+ncjSJaEuBjegDe5pv
         uiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696271472; x=1696876272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++pTUHyu/u7nbHx5/OgPMJ8ogjZFrTzCf1ydldSFYNQ=;
        b=lyR+nDjzlUPA8c9Vrgex61CDPRsb7xVB2r8o4oBlFhBN5fKC6kKK3Snzbq8yZxFWbh
         Q7QhlRW9Sh14Q/OK1WQZWqxknxNg4AZ2iKU+xDeeE6fUv1TylHAUs20is8Jt8SWDXLBN
         ua5De6R8EU8YFN8WAUo5fRV+YvfXDjr/OKQhNHy5+J8aQvMKj+lMf7uqMEMfg/jR9gDz
         YHKqiVA94BZZg6sdTskJ1ewjSOhEciE1kjnyrBDpnO8iMj+H516Y6p0Zkjq/AJ1whN5R
         bzrH66+gUNP+7gmy/3pyYIQHTFRJ2Xye/D0LmEc6VffT7TPzVhPHnW0cIlS3Dc4976wl
         y+eg==
X-Gm-Message-State: AOJu0YztlOqLIAY5ou1Lvsm9gc0P7u8EI+oF5IQSNojczSdDrr5hzghV
	D+0nXAosp6qPI9iX4nCF5vVl/kbEn50aBZzjAT9txQ==
X-Google-Smtp-Source: AGHT+IFnrycxYaz4VfaOXmSSqrisQHwimxGLT6f75i2/l9UllHUIbyadaa8EqFph6/sefsNk8K+Ulw==
X-Received: by 2002:a05:6e02:154c:b0:350:f0bb:6a3b with SMTP id j12-20020a056e02154c00b00350f0bb6a3bmr15532925ilu.17.1696271471795;
        Mon, 02 Oct 2023 11:31:11 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id t13-20020a02ccad000000b0042b451aa95esm6917696jap.150.2023.10.02.11.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 11:31:11 -0700 (PDT)
Date: Mon, 2 Oct 2023 12:31:02 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH] libtraceeval: Fix comparing unsigned against zero
Message-ID: <20231002183102.GA1512616@google.com>
References: <20230927041629.43ffbfd9@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927041629.43ffbfd9@rorschach.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 04:16:29AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> nr_key_types and nr_val_types are both size_t which is an unsized number.
> A compare against zero is always false:
> 
> 	if (teval->nr_key_types < 0)
> 
> Typecast it to signed for these comparisons.
> 
> Also change the few places the "size_t i" is used where it does:
> 
> 	for (; i >= 0; i--)
> 
> as that too needs to be signed to work.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/histograms.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/src/histograms.c b/src/histograms.c
> index 96f0926f062c..42959c154a11 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -159,7 +159,7 @@ static size_t type_alloc(const struct traceeval_type *defs,
>  {
>  	struct traceeval_type *new_defs = NULL;
>  	size_t size;
> -	size_t i;
> +	ssize_t i;
>  
>  	*copy = NULL;
>  
> @@ -196,7 +196,7 @@ fail:
>  	else
>  		print_err("traceeval_type list missing a name");
>  
> -	for (; i >=0; i--)
> +	for (; i >= 0; i--)
>  		free(new_defs[i].name);
>  	free(new_defs);
>  	return -1;
> @@ -303,14 +303,14 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
>  
>  	/* alloc key types */
>  	teval->nr_key_types = type_alloc(keys, &teval->key_types);
> -	if (teval->nr_key_types <= 0) {
> +	if ((ssize_t)teval->nr_key_types <= 0) {

Rather than casting, wouldn't it be better to just change the type of
nr_key_types and nr_val_types to ssize_t?  I think this should be the return
type of type_alloc() as well, since this returns -1 on error.

>  		err_msg = "Failed to allocate user defined keys";
>  		goto fail_release;
>  	}
>  
>  	/* alloc val types */
>  	teval->nr_val_types = type_alloc(vals, &teval->val_types);
> -	if (teval->nr_val_types < 0) {
> +	if ((ssize_t)teval->nr_val_types < 0) {
>  		err_msg = "Failed to allocate user defined values";
>  		goto fail_release;
>  	}
> @@ -785,7 +785,7 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
>  	union traceeval_data *copy = entry->vals;
>  	union traceeval_data old[teval->nr_val_types];
>  	size_t size = teval->nr_val_types;
> -	size_t i;
> +	ssize_t i;
>  
>  	if (!size)
>  		return 0;
> -- 
> 2.40.1
> 
