Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36211F956
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:03:46 +0000 (UTC)
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB66B4
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:03:43 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-79fa2dbd793so5542639f.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696277022; x=1696881822; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=um4uBUyWYa18hfMrg082Vp4YHWhqlAeoW24c7p1URyI=;
        b=Q5eD9YaxNzGuUDt5ZQkh98DbA8Y78qGI3z0iPi2VqPzN47UCBdJiabyjNOh4Nl8KFt
         DjNxS5C+4QKfCH579QK+euRo4JIysqoywRBa/4Dhu4Zk9m9zMW3QS+De+QR19rmryASV
         hmTCz7siau21GrkRQFIQXSlgHL0wxxyb/EYruc+kypsoVqxHAmWXmbt037Q0FSuvz6JS
         KiTg5qWGs+8ope3p3xpthDFWHB9y2qCdRDqrPFtHCu4U41zu4JONu+3M2Mwugofpd1Hm
         Z8mT+LB1LnlBzrzPUykBwl8bzsZcgytvuzMeB1oN+a/HrCdz/84sCPHNubglspEc3TwO
         uU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696277022; x=1696881822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=um4uBUyWYa18hfMrg082Vp4YHWhqlAeoW24c7p1URyI=;
        b=IKFCIzu9D+NuSGFPCH8/do9CQxcUoMRiIDdpQTaghmzZ7vWzSzAWMc8MK1BeJBHiwf
         crRforPwLEGoBNXcThJ4MvQWVvwePvVYZ71S7UEX+GA6UAUsCh3tOQAcZulWSI9ErWqu
         bCGYjr3BwC2SByGxDh3Vww9ccyDSFblvzVwQLv1sJ8K+RDm7eSgcBaegbNpszShwvjMX
         JCtievUTad2mXMDwb0Qa1WCLMRpXw6kIycBBYc9fd2tj6zIjMdZmHwgFMh5yEIKzGvQ/
         tFe9wY+aoPXTlPD6qdN+WZC/VDxMzBqtr8s+qgQJhuwdh9wBA3HXsL5aSNFr0RSQKv7A
         rC3A==
X-Gm-Message-State: AOJu0YxyooOGxuAXyYM/itfKHmObVs6vL7a8vGtJXWXNVILQnw+kCb6y
	HX48jLqiqu9+JvOJoy08Pd5r+cerXofjAPs6HkBOzQ==
X-Google-Smtp-Source: AGHT+IE/5r+dbxFHF5RoOcHKVjBNG1YJBJW3659duLnKCsHkvMRFGbUID+r2MxOWUrJbrlePqgXoew==
X-Received: by 2002:a05:6602:225a:b0:792:70f2:a8ed with SMTP id o26-20020a056602225a00b0079270f2a8edmr13706475ioo.4.1696277022211;
        Mon, 02 Oct 2023 13:03:42 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id v12-20020a5ec10c000000b00791e6ae3aa4sm37740iol.23.2023.10.02.13.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 13:03:41 -0700 (PDT)
Date: Mon, 2 Oct 2023 14:03:38 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 09/11] libtraceeval: Make traceeval_remove() check
 size of keys array
Message-ID: <20231002200338.GF1532181@google.com>
References: <20230927123314.989589-1-rostedt@goodmis.org>
 <20230927123314.989589-10-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927123314.989589-10-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 08:33:12AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Make traceeval_remove() into a macro to pass in the size of the keys
> array, and rename the function to traceeval_remove_size() that now takes
> the size of the keys array.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h | 7 +++++--
>  src/histograms.c         | 7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 7f48bb92cc96..804a0aaa631d 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -196,8 +196,11 @@ int traceeval_insert_size(struct traceeval *teval,
>  	traceeval_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
>  			      vals, TRACEEVAL_ARRAY_SIZE(vals))
>  
> -int traceeval_remove(struct traceeval *teval,
> -		     const struct traceeval_data *keys);
> +int traceeval_remove_size(struct traceeval *teval,
> +			  const struct traceeval_data *keys, size_t nr_keys);
> +
> +#define traceeval_remove(teval, keys)					\
> +	traceeval_remove_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys))
>  
>  int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
>  			 size_t nr_keys, const struct traceeval_data **results);
> diff --git a/src/histograms.c b/src/histograms.c
> index ab8a560fe14d..28cf0d4ed225 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -977,13 +977,16 @@ int traceeval_insert_size(struct traceeval *teval,

I think we need to update the comments above this function to account for the
new name and the additional 'nr_keys' param, but other than that you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>

>   *         0 if it did not find an time matching @keys
>   *        -1 if there was an error.
>   */
> -int traceeval_remove(struct traceeval *teval,
> -		     const struct traceeval_data *keys)
> +int traceeval_remove_size(struct traceeval *teval,
> +			  const struct traceeval_data *keys, size_t nr_keys)
>  {
>  	struct hash_table *hist = teval->hist;
>  	struct entry *entry;
>  	int check;
>  
> +	if (teval->nr_key_types != nr_keys)
> +		return -1;
> +
>  	entry = NULL;
>  	check = get_entry(teval, keys, &entry);
>  
> -- 
> 2.40.1
> 
