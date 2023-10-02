Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305061DDC3
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 21:18:32 +0000 (UTC)
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F802AB
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 14:18:30 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-79f82b26abfso7594639f.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 14:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696281510; x=1696886310; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FBVrv81aYcesv4I8gnGtwvKydjeB8MCE7zIiu55Uob0=;
        b=tkFqjuzgP692VXajZroPxwZYTRdoypM3ZFOvyuSNZkf2vD+IZCkwHAy9BPBarAyfR4
         xyFgV7IXqkRjulbmHwMbPbBlFgoAoD01qvmQI7c789VGztm+9M6YGi5Trxyj/p1xwUgU
         ovntsGZ66viY0YDAfnul6unJrZ2PeU6hCzi6reZlSKVXtndOxEQeZIM65wrABffk1hX/
         tMSyNrsQ3+gU2IaHWKzYgthRJhE8lrNaHO8m/530VldGbnqQd0W+mLxOury9hjkgfFEX
         2UZWpMv19PrJ+gekmIGfUKg38dTiJaP4JHourfbrNulEQD1c4Onsj0yLwEUR5LzsDDa6
         +TYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696281510; x=1696886310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FBVrv81aYcesv4I8gnGtwvKydjeB8MCE7zIiu55Uob0=;
        b=IjQTk7IX+0yD06/JO5a7wZWBsa7kv0CqYPuwtiXP5s4Yulj3izKpO4xzvAjGsHBeUi
         CNKhgZd76MmtPqwM9kGjiUtPlTFvDcrHwFm9XRUmCBSQtOKO6Rg9p4Hf6LuXqpLX6rCQ
         32zT3Og63GkAkgg+FwdEnADgsqdT/xkqxwLEPhUjf0vzYBNXqDBJHDxzXXn7gIJhYbIk
         9KgAnUomxMTUsbkZn1JPSWlTd3XtjMk+b7Gz6IyXjXoA6QIQO4J1vrlUxk2z4uXfEJ1p
         3DNV6sw67QKYa34ZfcE9sWTvxAyNYutCCH0solsU+duxazuHqo7AnMhPmqyjMdNURYoO
         ULOw==
X-Gm-Message-State: AOJu0Yy2gWIUY6yOtZFJya17MlQv8FQ8vACIQi8tEeUEKwCjQaZtNsRc
	BaUAeQAiE34MYqlkjzQh8uUrw6HFOGOaPa1v86JLdQ==
X-Google-Smtp-Source: AGHT+IHX+qrbDaZ8E5zZ7W7X505thFf/IG6FFRJKf7rjAIpIlukwvnjyosMzJcfCQKdf2fqoOaqzmg==
X-Received: by 2002:a6b:7f42:0:b0:795:16b8:8601 with SMTP id m2-20020a6b7f42000000b0079516b88601mr12958904ioq.0.1696281509703;
        Mon, 02 Oct 2023 14:18:29 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id j6-20020a6b7806000000b0078680780694sm76187iom.34.2023.10.02.14.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 14:18:29 -0700 (PDT)
Date: Mon, 2 Oct 2023 15:18:26 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 0/2] libtraceeval: Remove the need of TRACEEVAL_TYPE_NONE
Message-ID: <20231002211826.GO1532181@google.com>
References: <20230929100025.1018258-1-rostedt@goodmis.org>
 <20231002210749.GN1532181@google.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002210749.GN1532181@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Oct 02, 2023 at 03:07:49PM -0600, Ross Zwisler wrote:
> On Fri, Sep 29, 2023 at 06:00:23AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > The use of macros to determine the size of the keys and vals arrays made
> > me think a bit more about how we initialize the traceeval. The more I'm
> > using the library, the less I like having to add the TRACEEVAL_TYPE_NONE
> > to the end of the keys and vals array.
> > 
> > Instead, use the same macro trick of TRACEEVAL_ARRAY_SIZE() to determine
> > the number of elements. Still allow the use of using the
> > TRACEEVAL_TYPE_NONE to determine the size (if the number passed in is
> > still bigger), so that most applications that still use that still work.
> > 
> > I made the change separate than updating the sample code to test that
> > the old way still works. Then I updated the sample to make sure the new
> > way works. Perhaps when we add unit tests back in, we'll test both
> > cases.
> 
> Looks good, you can add:
> Reviewed-by: Ross Zwisler <zwisler@google.com>

Actually, I think we need to make similar updates in check_keys() and
check_vals(), else calls to traceeval_init_data_size() will walk off the end
of those respective arrays.

> 
> > Steven Rostedt (Google) (2):
> >   libtraceeval: Remove need to use TRACEEVAL_TYPE_NONE in keys and vals
> >   libtraceeval samples: Remove adding TRACEEVAL_TYPE_NONE to keys and
> >     vals
> > 
> >  include/traceeval-hist.h | 11 +++++++++--
> >  samples/task-eval.c      | 18 ------------------
> >  src/histograms.c         | 11 +++++++----
> >  3 files changed, 16 insertions(+), 24 deletions(-)
> > 
> > -- 
> > 2.40.1
> > 
