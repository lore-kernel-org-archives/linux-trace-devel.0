Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F85A266C8
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Oct 2023 21:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0qHEzIM7"
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BD295
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Oct 2023 14:25:26 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-79fd60f40ebso49438039f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Oct 2023 14:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696541126; x=1697145926; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIazRDfFrOcbJTnmWzAAJdmbCgIFd+3IwoXweuh0wEE=;
        b=0qHEzIM7ndoDTztK8riyZSqnBxbl8ejJJQTH4/oheGBPmegfuXjab0dLoUzK/fC3ku
         AT3WcTr7WMHtb/HL9OJoLbJpm5+BY3ZsHRswbbsuqAleXqc2pbq7dL/mDylyodlBlceu
         Xgysfx0oEj4N40EHSWmMKdT6o2/JCJlySkjl7C9ZMlCzMQjV95+7mHdU3OfSUZki84TA
         S/oAm1knd3EPF9aaxSNxXZnXoIzq/RFx9+PPqa0yA2x1WpZtaWR0k3H5/O3juKEOwu2i
         JxRimGTJoiOVv3C6Q69TRckHFQzCy4B11RRgj3ec5zoAlrq7lbj+mCJSqoAYmaE0Vaaf
         NaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696541126; x=1697145926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIazRDfFrOcbJTnmWzAAJdmbCgIFd+3IwoXweuh0wEE=;
        b=DjpFuF8h6XXHYLhNZdt9UCFRRxMQBa6FqQCYvAtRKhfyu6XFQP4GTGB6LkeYs+6gYF
         3oBBZFWs6G/T37K26Ky8ybpfE2m/n0ExFm6N/ar0NVcEoAWS4rHZmkGc/MwuXzIuz2hx
         YCYzZOIT9pFKWwDYCDAUb9zoGI/zLdPmdaJfEOJ/DsGIIEgquprE7IwV2kaN5UzhbhKw
         a7/Hzyh3i8gDHZ4hfivFu297XTzNvLAWs9Rqn5NX1GJzxjaHsiUij34P+sj8mYShrFEf
         3FZgY7TR7fXe2/xTdi0zSr+b8J0jxfKGrYGbJkQ6FmGR26xUNPu4XIg1fj3Tc8V6kV0u
         jGVw==
X-Gm-Message-State: AOJu0YwNsym0UJSyhVki8s5Ly+MJJJYwovQMOIX5YrkpGvp1aJMjyC9I
	Td5hhHQzQXWjQw8Q3mqeK+iuBozVG/krKKcFMF/Flw==
X-Google-Smtp-Source: AGHT+IHwjmNfmFhhYjlqoBgzvugNTw81b4+zC2ieAvJaWH43XW0p52lFeWiJjdDv81CPgXnOCzklsg==
X-Received: by 2002:a5d:9da3:0:b0:790:aed5:d0b0 with SMTP id ay35-20020a5d9da3000000b00790aed5d0b0mr3923517iob.0.1696541125995;
        Thu, 05 Oct 2023 14:25:25 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8c22:bb19:99aa:e163])
        by smtp.gmail.com with ESMTPSA id e7-20020a5d8ac7000000b007922dc27aa6sm172019iot.24.2023.10.05.14.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 14:25:25 -0700 (PDT)
Date: Thu, 5 Oct 2023 15:25:21 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH] libtraceeval: Use trick to force static array usage
 where needed
Message-ID: <20231005212521.GA3146009@google.com>
References: <20231004185225.366c1739@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004185225.366c1739@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Oct 04, 2023 at 06:52:25PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Some functions use the TRACEEVAL_ARRAY_SIZE() macro to determine the size
> of the array passed to it. But this will not work if the developer uses a
> pointer to the array. gcc may give a warning, but it will still happily
> compile it leaving the developer wondering why their code does not work.
> 
> Use a little trick that checks and tests if the array is static, and will
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
> pointers are compatible [ (a, b) where a = b is valid ]. For a static
> array, we would have
> 
>  struct traceeval_data data[5]
> 
> Where typeof(data) is "struct traceeval_data []" and the type of
>  &data[0] is a pointer to "struct traceeval_data", and the above
> would return false (zero) [ data = &data[0] is invalid ].
> 
> For pointers:
> 
>  struct traceeval_data *data;
> 
> Then type of data is the same as &data[0] and it would return true (1).
> [ data = &data[0] is valid ]
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
>     int: 0; // structure with int size of 0 bits
>  }
> 
> Which is perfectly valid. But if <result> returned true (as it would if it
> was a pointer and not a static array), then it would be:
> 
>   struct {
>      int: -1;  // structure with int size of -1 bits!
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
> Of course, the developer will likely now scratch their head on why it
> doesn't build, but that's because they didn't RTFM!
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

That's some scary deep magic.  :)

We may want to add a comment above this to briefly explain, i.e. "This macro
will fail to build if 'data' is a pointer and not a static array" and refer
them to the commit history?  That way they have some way to proceed if/when
their build fails.

Otherwise looks good:
Reviewed-by: Ross Zwisler <zwisler@google.com>

> ---
>  include/traceeval.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/traceeval.h b/include/traceeval.h
> index 4cc5eb6ef3de..6c6e09c53129 100644
> --- a/include/traceeval.h
> +++ b/include/traceeval.h
> @@ -17,7 +17,12 @@
>  /* Field name/descriptor for number of hits */
>  #define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
>  
> -#define TRACEEVAL_ARRAY_SIZE(data)	(sizeof(data) / sizeof((data)[0]))
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
