Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E0224A16
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 22:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JvBkGqxB"
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03D691
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 15:33:52 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-79f9acc857cso14043139f.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 15:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697063632; x=1697668432; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YLA+MnXZ3Um6yalNJ07GjA2IVowN1zsW9UYBvq1syVE=;
        b=JvBkGqxBv0rpTaq5GNqSC2ggf0NiT14VhVZesgXJqpvuDT/3kdPWEuwAZjwGZ1GxDx
         7uCq1FdNdMGJzvQAgGTg5U5ZfVdSjqzpuF+IQOFVqdvRmIf3HB8zb5G1OApB/TAYh8Yx
         V/0296AV0SFbM4kI2GieAx2RuZxcWYegb0CcUSVPSwyGrVc2z0gsoBgIJ3sbF5WoCx5d
         oE13Ee3TeRz0LAJBFGP96m53P30Ui1hGd0BVLBQFD37OgGks/ctMJ6dXYs8ktSuf15eu
         1qnUnjgin9s6KfXP1E/yDCCh4sKjmJo85AcpSrSbNBSFXj9Cnngnm03VwmF8ww+GITrA
         9WGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697063632; x=1697668432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLA+MnXZ3Um6yalNJ07GjA2IVowN1zsW9UYBvq1syVE=;
        b=tA9sHLs14kTcvPt93Wyl8KdWGvxl83YK2RS1voQa3HPm4J9l/qGKVQq2gTfKQIcrz0
         PeeWQZZPNbpXv0nMqprZJUV36q5UWYMKqaitIneIOfTvlKgF0x2UyCIoUqI/4JFKWfgS
         KkgiH6GberPz+CAZ+uSIF12Sef/6djo20GwKVJ5sBPukrdzKD0XFzDmU9r3CN/YWs/vb
         M1aF1I0YqdjG7zPlV7F27AlhMSB9Z/3a6/0PvnwGbgmGMhODibstm44HBEBqVCpnWVm3
         bNSW+beMvGKu0tfweP22yVOFvG7SGY9YHFpCnpmsnEEoQKYCJbfYqlZZmdkilW/GKSeW
         BQGQ==
X-Gm-Message-State: AOJu0YymW+HGWM2j4N1OoAdHKXIlKVV6dcjHg3dnG8+R1woW6z9kQVs5
	Jf3zFX2J8dMOBD9onFIdjnPtCWImGTLduIOIT91BIQ==
X-Google-Smtp-Source: AGHT+IFvV4pT3wulFQaeOA5I8M325lti9gkQWunD83tad+ld34hQTemIhQlxXdanpcHzztSnNDdnxQ==
X-Received: by 2002:a5e:c10c:0:b0:79f:97b6:76de with SMTP id v12-20020a5ec10c000000b0079f97b676demr25964958iol.3.1697063631959;
        Wed, 11 Oct 2023 15:33:51 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:6fb5:b607:f4ac:85])
        by smtp.gmail.com with ESMTPSA id o16-20020a02cc30000000b0042bb296863asm3540340jap.56.2023.10.11.15.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 15:33:51 -0700 (PDT)
Date: Wed, 11 Oct 2023 16:33:48 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2] libtraceeval: Have TRACEEVAL_ARRAY_SIZE() handle NULL
 pointer
Message-ID: <20231011223348.GB94116@google.com>
References: <20231005212233.22ae4e13@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231005212233.22ae4e13@rorschach.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Oct 05, 2023 at 09:22:33PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> In the new addition to make sure that pointers passed to traceeval_init()
> and other functions that require a static array and not a dynamic one will
> cause the build to fail, this causes NULL pointers to fail the build too.
> 
> Although keys must be filled, vals are allowed to be NULL. It was assumed
> that:
> 
>    (void *)vals == NULL ? TRACEEVAL_ARRAY_SIZE(vals))
> 
> Would solve this, but it gcc was actually still giving a warning about
> 
>   warning: division 'sizeof (void *) / sizeof (void)' does not compute the number of array elements
> 
> But now it actually fails to build with the magic check.
> 
> Change TRACEEVAL_ARRAY_SIZE() to handle NULL for both keys and vals, by
> not only having:
> 
>  #define TRACEEVAL_ARRAY_SIZE(data) \
> 	((void *)(data) == NULL ?  0 : __TRACEEVAL_ARRAY_SIZE(data))
> 
> But that is not enough, as gcc still evaluates the second part, and it
> will fail to build. To handle this, change that to:
> 
>  #define __TRACEEVAL_ARRAY_SIZE(data)					\
> 	((sizeof(data) / (sizeof((data)[0])) + 0) +			\
> 
> The above adds " + 0" to the "sizeof((data)[0])" which quiets the warning
> mentioned above (the addition of zero breaks the normal pattern of finding
> an array size).
> 
> 	(int)(sizeof(struct {						\
> 		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
> 						      typeof(&((data)[0]))) && \
> 			 (void *)(data) != NULL));			\
> 
> Added "&& (void *)(data) != NULL" that makes the above return false (zero)
> for a static array and NULL, which is exactly what we want.

Don't we already know it's not NULL because of the check in
TRACEEVAL_ARRAY_SIZE()?  Or do we really need to check for NULL in both
macros?

> 
> 			})))

A few random parens in the changelog. :)

> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/all/20231005205129.6d6cbfad@gandalf.local.home/
> 
> - Fixed error in placement of parenthesis.
> 
>  include/traceeval.h | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/traceeval.h b/include/traceeval.h
> index bbf8f6ac7dd1..d8095ba5c1a1 100644
> --- a/include/traceeval.h
> +++ b/include/traceeval.h
> @@ -29,13 +29,17 @@
>   *
>   *    struct traceeval_data keys[] = { ... };
>   */
> -#define TRACEEVAL_ARRAY_SIZE(data)					\
> -	((sizeof(data) / sizeof((data)[0])) +				\
> +#define __TRACEEVAL_ARRAY_SIZE(data)					\
> +	((sizeof(data) / (sizeof((data)[0]) + 0)) +			\
>  	(int)(sizeof(struct {						\
>  		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
> -						      typeof(&((data)[0]))))); \
> +						      typeof(&((data)[0]))) && \
> +			 (void *)(data) != NULL));			\
>  			})))
>  
> +#define TRACEEVAL_ARRAY_SIZE(data) \
> +	((void *)(data) == NULL ?  0 : __TRACEEVAL_ARRAY_SIZE(data))
> +
>  /* Data type distinguishers */
>  enum traceeval_data_type {
>  	TRACEEVAL_TYPE_NONE,
> @@ -191,7 +195,7 @@ struct traceeval;
>  #define traceeval_init(keys, vals)					\
>  	traceeval_init_size(keys, vals,					\
>  			    TRACEEVAL_ARRAY_SIZE(keys),			\
> -			    (void *)vals == NULL ?  0 : TRACEEVAL_ARRAY_SIZE(vals))
> +			    TRACEEVAL_ARRAY_SIZE(vals))
>  
>  #define traceeval_init_size(keys, vals, nr_keys, nr_vals)		\
>  	traceeval_init_data_size(keys, vals, nr_keys, nr_vals,		\
> @@ -211,7 +215,7 @@ int traceeval_insert_size(struct traceeval *teval,
>  
>  #define traceeval_insert(teval, keys, vals)				\
>  	traceeval_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
> -			      vals, (void *)vals == NULL ? 0 : TRACEEVAL_ARRAY_SIZE(vals))
> +			      vals, TRACEEVAL_ARRAY_SIZE(vals))
>  
>  int traceeval_remove_size(struct traceeval *teval,
>  			  const struct traceeval_data *keys, size_t nr_keys);
> -- 
> 2.40.1
> 
