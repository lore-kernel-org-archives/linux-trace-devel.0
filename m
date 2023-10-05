Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD2E41E45
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Oct 2023 22:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e+YOaJMU"
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BB59E
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Oct 2023 15:02:59 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-35140cc9187so6571145ab.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Oct 2023 15:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696543378; x=1697148178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lnyWeH4qaAVEDMR6jQbvoffDTKG9ouVhogo78d4WJBQ=;
        b=e+YOaJMUjUJfYVSTmMJcuVTKJlA7/0c5c3ozm5MOdSelQP+gG/yuJ5osI0Vh8RhxJd
         41e81YY68rqumAK1IywFecX1aR4vpm6Em4F3yBXnDDt026XTqJwgNnkCqXMnn2XAKwGW
         bGXIRwY/Yr8up2qfcBi58OWjt/fxSRG0b22rNNDKC9gtat4sDmfsaFylpr6ZOx+U7/Uf
         nV+9NMzGzKGZK9SsB4/eCjO/3TsWnSJnGzvlmyCql6g+4JEHjK8e3UORzDJF/OWMMXUO
         G7OdNnPDVLBQRt4A8KETyBYEd0t2gd5rSknK9cc6jjptnCT5Ai2dvn/FZVaxqMqtNDW5
         IOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696543378; x=1697148178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnyWeH4qaAVEDMR6jQbvoffDTKG9ouVhogo78d4WJBQ=;
        b=YJBOMFwdhAFIFuc3WtKIlxvnLALaAI08rc+emVg7aXDFgJVN4d05LIyeZ6Zg5dwgfC
         oip2ZX33nx7w3updT6XflMzEJ5bamewj8Z0cM5ue2uCyEO/ojLZEY/zUteF+gZbj4T5q
         BwDIqHAQe5nTfs41YgC3stfXTPb7/nR1/0AK1giKmksOUgbCyM3MSeB0+qUcsrN3miha
         DSyeL8Tj0hvEm3yxIvmqbtK0/B89+XnWmwyYztGA1/JNhL9eaJF9DEdjy4WNwOad9Kqx
         Q+x6ACBMaeDRtL95g6bFu45+393kwJHylr/0gLc3qx1ucx7P+YgzT7EAQJOQBhliVxvD
         ykaQ==
X-Gm-Message-State: AOJu0Yw3LjuY8hEphSECPL/JAt7xT9dE8tbD//G4nW2xSN8xRxaco8vL
	4hbVrZUf5NFa1efllaxhs3EVBA27YFrifi3iw8brBA==
X-Google-Smtp-Source: AGHT+IHAAFeLwrJmsyVbUrB4BsSzlkFWwPbigRkObJYAdD9GZLpLujBYN/UMw6dH2o0g7y/o2nfwTQ==
X-Received: by 2002:a05:6e02:11aa:b0:351:59db:a20e with SMTP id 10-20020a056e0211aa00b0035159dba20emr5577506ilj.18.1696543378539;
        Thu, 05 Oct 2023 15:02:58 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8c22:bb19:99aa:e163])
        by smtp.gmail.com with ESMTPSA id p4-20020a92d684000000b0035146678bd5sm669455iln.65.2023.10.05.15.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 15:02:58 -0700 (PDT)
Date: Thu, 5 Oct 2023 16:02:55 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2] libtraceeval: Use trick to force static array usage
 where needed
Message-ID: <20231005220255.GA3160669@google.com>
References: <20231005180228.32449777@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231005180228.32449777@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Oct 05, 2023 at 06:02:28PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Some functions use the TRACEEVAL_ARRAY_SIZE() macro to determine the size
> of the array passed to it. But this will not work if the developer uses a
> pointer to the array. gcc may give a warning, but it will still happily
> compile it leaving the developer wondering why their code does not work.
> 
> Use a little trick that checks that tests if the array is static, and will
> fail the build if it is not.
> 
>  #define TRACEEVAL_ARRAY_SIZE(data)					\
> 	((sizeof(data) / sizeof((data)[0])) +				\
> 	(int)(sizeof(struct {						\
> 		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
> 						      typeof(&((data)[0]))))); \
> 			})))
> 
> Going backwards to explain the above, we have:
> 
>   __builtin_types_compatible_p(typeof(data), typeof(&((data)[0]))
> 
> Which is a gcc/clang compiler directive that returns true if the two
> pointers are compatible. For a static array, we would have
> 
>  struct traceeval_data data[5]
> 
> Where typeof(data) is "struct traceeval []" and the type of
>  &data[0] is a pointer to "struct traceeval_data", and the above
> would return false (zero).
> 
> For pointers:
> 
>  struct traceeval_data *data;
> 
> Then type of data is the same as &data[0] and it would return true (1).
> 
> Now we have a structure defined:
> 
>   struct {
>     int: (-!!(<result>));
>   }
> 
> Which if <result> of the __builtin_types_compatible_p() returned false
> (zero), then it would be:
> 
>   struct {
>     int: 0;
>  }
> 
> Which is perfectly valid. But if <result> returned true (as it would if it
> was a pointer and not a static array), then it would be:
> 
>   struct {
>      int: -1;
>   }
> 
> Which is not valid to compile, and the build will fail.
> 
> But in order to make sure this is in the code that uses
> TRACEEVAL_ARRAY_SIZE(), it needs to be part of the computation. To do
> that, as "struct { int:0; }" is of size zero, we can simply add a sizeof()
> around it, and attach the above with an addition "+".
> 
>  ... + sizeof((int)(sizeof(struct { int:0;}))) is the same as:
> 
>  ... + 0
> 
> Now with this logic, if a pointer is passed to something like
> traceeval_init(), it will fail to build, and not cause hours of scratching
> head debugging for the developer at runtime.
> 
> Of course, the developer will likely to now scratch their head on why it
> doesn't build, but that's because they didn't RTFM!
> 
> Reviewed-by: Ross Zwisler <zwisler@google.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/linux-trace-devel/20231004185225.366c1739@gandalf.local.home/
> 
>  - Added comment to why the compile may fail due to the above trick.
> 
>  include/traceeval.h | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/include/traceeval.h b/include/traceeval.h
> index 4cc5eb6ef3de..a70a5b09057b 100644
> --- a/include/traceeval.h
> +++ b/include/traceeval.h
> @@ -17,7 +17,24 @@
>  /* Field name/descriptor for number of hits */
>  #define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
>  
> -#define TRACEEVAL_ARRAY_SIZE(data)	(sizeof(data) / sizeof((data)[0]))
> +/*
> + * If your compile failed due to the below macro, it is likely you used
> + * a pointer to struct traceeval_data, and not a static array.
> + *
> + * That is:
> + *
> + *    struct traceeval_data *keys;
> + *
> + * and not:
> + *
> + *    struct traceeval_data keys[] = { ... };
> + */

Perfect, thanks!

> +#define TRACEEVAL_ARRAY_SIZE(data)					\
> +	((sizeof(data) / sizeof((data)[0])) +				\
> +	(int)(sizeof(struct {						\
> +		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
> +						      typeof(&((data)[0]))))); \
> +			})))
>  
>  /* Data type distinguishers */
>  enum traceeval_data_type {
> -- 
> 2.40.1
> 
