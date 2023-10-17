Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9A2436AF
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0XFqfJRX"
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F051FA
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 07:48:00 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-79fa2dbd793so245957539f.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 07:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697554079; x=1698158879; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kHAqcY5mRhrYDzqXW+Yc4wH5oSg2S5zFi96Hk8TQttw=;
        b=0XFqfJRXb3el+7YYgoyphIZclBTqCSHTC8xztdWh9zygrKSlb6JeebASQJSPyEN3Gg
         /SbltDzs+o7IGoRjuSrZ7wLasFDOqi37rNQhWRAUjbAS1azvf8WWkciNO9NWYuCSrDmQ
         PbZ4AD+nPfSbtaA/q5Om/bhJgju5XGbcvb+mcMq1HlAqab7TI1kUeRE8kUzjvIDXBHd2
         Y+rMiym5KwfATkZxiIDawWhtulGYI4xohWPKU6Cr855lsWPu4dx+dj7RAuKqz0bg8Yfa
         39sb8udW4sgar39T+bnZMuQXS6W+FV+pYgct9WwW5DSHwyFO3qDYmqPSTQU3zYA7Mvme
         r5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697554079; x=1698158879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHAqcY5mRhrYDzqXW+Yc4wH5oSg2S5zFi96Hk8TQttw=;
        b=H0kTdxv5oL6k/Z1Vq0XrIUKShpQzDpM6tEKEze/zPNRi5w5pe7ez7TZ3/bAnzqnaNa
         WKSERKUKMpdF4W5bS95KpDu2qOnd+FM48ddAaC4xvfXiRAun7mc8E3gL1dGCusBGRFEb
         BWJSs7fFY46wKaoZHCMDH4ieBdlbcFM/9eO3stpcOSjfqRVC+fEvipfSryf+v5+RcBH3
         jxwFMWFnPbXl95N1BXN8Z7Pp+AKYsFWIbuYrH19RLc/Wjl1tUd27AK+bJPrfvO2mTNfq
         PIOWxZEadagtkF5RBpFhMRiqIzOIos5077IKEHRr5f4QJ5oqoP30NMCEBCrLPD9ruNIP
         dP/g==
X-Gm-Message-State: AOJu0YxvxsW+5J6OMKhOLx4LAdTaGhJL19d/oaG6wvitQtcBhXzO6J4C
	6Eo4swoWkUg8oA57XQWuTfxWzRDp2UsRytC4oug5hQ==
X-Google-Smtp-Source: AGHT+IF/szHn2XMHEdSAWcMrdWPdfkmKWsLa1zu7nOuomi32c8DIS5EqHrk+Cxphblr5E6mzDggD9g==
X-Received: by 2002:a05:6e02:2145:b0:350:f352:4853 with SMTP id d5-20020a056e02214500b00350f3524853mr3169362ilv.25.1697554079385;
        Tue, 17 Oct 2023 07:47:59 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:41f1:c358:ee10:50d2])
        by smtp.gmail.com with ESMTPSA id fs2-20020a05663865c200b0042b35e163besm538495jab.88.2023.10.17.07.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 07:47:58 -0700 (PDT)
Date: Tue, 17 Oct 2023 08:47:56 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2] libtraceeval: Have TRACEEVAL_ARRAY_SIZE() handle NULL
 pointer
Message-ID: <20231017144756.GA3977037@google.com>
References: <20231005212233.22ae4e13@rorschach.local.home>
 <20231011223348.GB94116@google.com>
 <20231011191406.5c93f6ae@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011191406.5c93f6ae@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Oct 11, 2023 at 07:14:06PM -0400, Steven Rostedt wrote:
> On Wed, 11 Oct 2023 16:33:48 -0600
> Ross Zwisler <zwisler@google.com> wrote:
> 
> > On Thu, Oct 05, 2023 at 09:22:33PM -0400, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > > 
> > > In the new addition to make sure that pointers passed to traceeval_init()
> > > and other functions that require a static array and not a dynamic one will
> > > cause the build to fail, this causes NULL pointers to fail the build too.
> > > 
> > > Although keys must be filled, vals are allowed to be NULL. It was assumed
> > > that:
> > > 
> > >    (void *)vals == NULL ? TRACEEVAL_ARRAY_SIZE(vals))
> > > 
> > > Would solve this, but it gcc was actually still giving a warning about
> > > 
> > >   warning: division 'sizeof (void *) / sizeof (void)' does not compute the number of array elements
> > > 
> > > But now it actually fails to build with the magic check.
> > > 
> > > Change TRACEEVAL_ARRAY_SIZE() to handle NULL for both keys and vals, by
> > > not only having:
> > > 
> > >  #define TRACEEVAL_ARRAY_SIZE(data) \
> > > 	((void *)(data) == NULL ?  0 : __TRACEEVAL_ARRAY_SIZE(data))
> > > 
> > > But that is not enough, as gcc still evaluates the second part, and it
> > > will fail to build. To handle this, change that to:
> > > 
> > >  #define __TRACEEVAL_ARRAY_SIZE(data)					\
> > > 	((sizeof(data) / (sizeof((data)[0])) + 0) +			\
> > > 
> > > The above adds " + 0" to the "sizeof((data)[0])" which quiets the warning
> > > mentioned above (the addition of zero breaks the normal pattern of finding
> > > an array size).
> > > 
> > > 	(int)(sizeof(struct {						\
> > > 		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
> > > 						      typeof(&((data)[0]))) && \
> > > 			 (void *)(data) != NULL));			\
> > > 
> > > Added "&& (void *)(data) != NULL" that makes the above return false (zero)
> > > for a static array and NULL, which is exactly what we want.  
> > 
> > Don't we already know it's not NULL because of the check in
> > TRACEEVAL_ARRAY_SIZE()?  Or do we really need to check for NULL in both
> > macros?
> 
> Unfortunately what happens is that the compiler still checks the above. So
> if we have just:
> 
>  	(int)(sizeof(struct {						\
>  		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
>  						      typeof(&((data)[0])))));
> 
> 
> Then the with NULL turns into:
> 
> 	struct { int: -1; }
> 
> and fails the compile because:
> 
>  		__builtin_types_compatible_p(typeof(NULL), typeof(&((NULL)[0])))
> 
> Returns true.
> 
> So if we pair that with (void *)(data) != NULL, it will then return false
> and turns into:
> 
> 	struct { int: 0; }
> 
> Which is valid.

Sounds good. If you haven't landed this already you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>
