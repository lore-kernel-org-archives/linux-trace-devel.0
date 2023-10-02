Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D885B20304
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 21:07:58 +0000 (UTC)
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D224EE
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 14:07:54 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-3527428a402so695265ab.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 14:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696280873; x=1696885673; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ph9vNJJH6893jItrR+idv6NvNXpN8x22eQQjZod6+Bc=;
        b=vy/4jmsvHexMW9PF3GdR1e3l1eRwhSpaITY5w/ZK1ymA0QX5avxRLJocauGiGzQTsr
         F3AJwLT1RpOlA/gHpJJNPKdGtAqOP9IAr9sAiYYtMvTSH3uX0Oge6LUQixs+Gl9UMtyq
         NXy9/FESHRPGd4MqDQo2ODpBavP/jIr9LRQKmhYlsMSkOUDO8XBFbzepAEmEcn+weIB+
         CvQev3P7mxkhi+5fd3oq6VnKdOn9ouLjNdXylu1W5LR2g0Q498Q5ivb9nQ1Y1iS3IsYY
         Jc3ye4OKq9/IJ7U5NeUwsnH5jaMoEru1Wo2JRT9+tfAHusbEaINqQjn+gaqnlXQ/XuAh
         82Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696280873; x=1696885673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ph9vNJJH6893jItrR+idv6NvNXpN8x22eQQjZod6+Bc=;
        b=cXl2sFQxpTnMbXScpv0wuWM9OLxQgoYegt9HFKOpKcZ/1rodWsSYAvmAjbcCLngp2w
         ejXtbQi62KBUMNStTIOxAZhnZtWf5fbauAWSqbnsWpNkB52buNqhtZ9e+aScxOmLSA8x
         pqHDXK1eGY8IEJXiSdvE5u63f87l36TqEsSD/jJ0xUT//Uh1MIru3G0a3zdR1Cik5fmE
         xLqr/gfV5L7HcTtcvl+YsfdN9IwDTe2dVxUbzR1xhw3fs+o+XHaHWPQgzxibF2OaL0MW
         oYcfsRXsp27lnqcKCUnunsOHIG0UWixz+tOSJWeLQVF/PrIRNgVnDFSzD9TYu9/eP1ra
         NDFg==
X-Gm-Message-State: AOJu0Yx0uu+iAFobfxEr6aeuEKkUXE6/8r5Fsn/KfulVwkpHKdTMuMYK
	GrDh92W4gidZRetJP6UMZfePfQ==
X-Google-Smtp-Source: AGHT+IH5tGNGGWBOgV6mWjtGR4YvtalJE0x495SeQJ2AUe8z07a+RSDb7yEV7oCx9tFg/1uXqEQepQ==
X-Received: by 2002:a05:6e02:1203:b0:351:5cdb:225c with SMTP id a3-20020a056e02120300b003515cdb225cmr12408237ilq.17.1696280873367;
        Mon, 02 Oct 2023 14:07:53 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id c18-20020a056e020cd200b003515cdb8f23sm4233280ilj.32.2023.10.02.14.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 14:07:52 -0700 (PDT)
Date: Mon, 2 Oct 2023 15:07:49 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 0/2] libtraceeval: Remove the need of TRACEEVAL_TYPE_NONE
Message-ID: <20231002210749.GN1532181@google.com>
References: <20230929100025.1018258-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929100025.1018258-1-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Sep 29, 2023 at 06:00:23AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The use of macros to determine the size of the keys and vals arrays made
> me think a bit more about how we initialize the traceeval. The more I'm
> using the library, the less I like having to add the TRACEEVAL_TYPE_NONE
> to the end of the keys and vals array.
> 
> Instead, use the same macro trick of TRACEEVAL_ARRAY_SIZE() to determine
> the number of elements. Still allow the use of using the
> TRACEEVAL_TYPE_NONE to determine the size (if the number passed in is
> still bigger), so that most applications that still use that still work.
> 
> I made the change separate than updating the sample code to test that
> the old way still works. Then I updated the sample to make sure the new
> way works. Perhaps when we add unit tests back in, we'll test both
> cases.

Looks good, you can add:
Reviewed-by: Ross Zwisler <zwisler@google.com>

> Steven Rostedt (Google) (2):
>   libtraceeval: Remove need to use TRACEEVAL_TYPE_NONE in keys and vals
>   libtraceeval samples: Remove adding TRACEEVAL_TYPE_NONE to keys and
>     vals
> 
>  include/traceeval-hist.h | 11 +++++++++--
>  samples/task-eval.c      | 18 ------------------
>  src/histograms.c         | 11 +++++++----
>  3 files changed, 16 insertions(+), 24 deletions(-)
> 
> -- 
> 2.40.1
> 
