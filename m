Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33D8347B1
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 18:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0Wgny/V"
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD5990
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 11:47:40 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-79fe87cd74eso241120939f.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 11:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697568459; x=1698173259; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YEaF72e9OflNHjQy5WNvTNHiOgb5YU8sUFMxN5UC1GI=;
        b=s0Wgny/VFbIq/ViBKaz/sQwce2P6O1zcbkmQrpGeE2avA9TulMWzUkhjgWhsVMB5TS
         jpDovWnuDEYqg+EOusQvXoRiLpUYuQzoe5csKb3B8wtL++TYbimIXHXoulwAY2JMqOJW
         pINhVPKILcyNDVRS1kX9IGIQKSr/rjx98d1SOAvOT1mO4HYd+jJydgGbRmAm6QRqY/1U
         Lw3SpPDSCMk8GMQtFfJKuCfwlkcxmndkRqSXp3XlnUkAuiCwdAVrKVbgfTu+m1AsP9oi
         i++dsAup6cyqUnv9TXmgbNk5gRFaoTcP0vdROLUbRy4TdcnnZT6u6Aoj3xUBaDS3TGjz
         nOPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697568459; x=1698173259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEaF72e9OflNHjQy5WNvTNHiOgb5YU8sUFMxN5UC1GI=;
        b=GIxiHCm5AyUd72+AnizC12wEv81lC1uIsvmWf3mjhlVs6YBhyaDdA29GGtl+mffWc6
         z+7FV8JYCJa2IpipuQKjbMYt0CC/7xTdO8G0+vr0VDlGBaDpteE548OWbNJR+NhFB/5Z
         i34dIrlB9CgPaBFiVjdDW0Xr4XXdnZ9GvjXhkq+hAS/B9oMohXwHJi7qGm1Q5vVo4BO/
         WkzZYnh1e0Nb5wQdi0NSY7vaBZPeXiX4h6iSU/dxNiFdV2Z1IkAAm583MmcFbYAHTtZg
         lIUp9A/zAWcislsuhBUj+Wc6ZqCPbUPp5L2VxInAb5HnkxXxvEK1+2Tl+At3yRYTHNi+
         KXhQ==
X-Gm-Message-State: AOJu0Ywv7dN/O7zNTkO5j7LeF/lzTMzUUyS+bl/8Mhw26yS/o24XbKuf
	waGniCFiuDR464+F4rJRg54QJg==
X-Google-Smtp-Source: AGHT+IE9591WDcukDvbjorih/6RD6O6lRUFPfAEpm4DFO72GYyD/jlat/3qzMUpURePzSmqrtCNcbA==
X-Received: by 2002:a05:6602:1490:b0:786:f352:e3d4 with SMTP id a16-20020a056602149000b00786f352e3d4mr4073677iow.7.1697568459626;
        Tue, 17 Oct 2023 11:47:39 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:9133:d08e:1c51:184])
        by smtp.gmail.com with ESMTPSA id k3-20020a0566022a4300b0077a1b6f73b9sm575180iov.41.2023.10.17.11.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 11:47:39 -0700 (PDT)
Date: Tue, 17 Oct 2023 12:47:36 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtraceeval: Add traceeval_stat_max/min_timestamp() API
Message-ID: <20231017184736.GB3977037@google.com>
References: <20231005181448.176e9563@gandalf.local.home>
 <20231011222100.GA94116@google.com>
 <20231011190917.1d57a7e9@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011190917.1d57a7e9@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Oct 11, 2023 at 07:09:17PM -0400, Steven Rostedt wrote:
> On Wed, 11 Oct 2023 16:21:00 -0600
> Ross Zwisler <zwisler@google.com> wrote:
> 
> > On Thu, Oct 05, 2023 at 06:14:48PM -0400, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > > 
> > > If a value field is flagged as a TIMESTAMP, and another field is flagged
> > > as a STAT, have the statistics for the STAT field automatically keep track
> > > of when the max and min happened (what the TIMESTAMP field was at those
> > > instances).  
> > 
> > I'm confused as to why we have TRACEEVAL_FL_TIMESTAMP and a separate data
> > entry with that flag, instead of only storing the timestamp in the entry
> > metadata, as we do with the other STATs?
> 
> Actually, I may remove this part entirely, as it's pretty much superseded
> by the TRACEEVAL_TYPE_DELTA, which I moved to, and haven't needed the
> separate val marked for the timestamp.
> 
> > 
> > >From the description above where we have one TIMESTAMP and one STAT, I would  
> > expect to see structures defined like this
> > (from [PATCH v2] libtraceeval: Add wake-lat sample code):
> > 
> > +struct traceeval_type sched_vals[] = {
> > +       {
> > +               .name           = "timestamp",
> > +               .flags          = TRACEEVAL_FL_TIMESTAMP,
> > +               .type           = TRACEEVAL_TYPE_NUMBER_64,
> > +       },
> > +       {
> > +               .name           = "delta",
> > +               .flags          = TRACEEVAL_FL_STAT,
> > +               .type           = TRACEEVAL_TYPE_NUMBER_64,
> > +       }
> > 
> > where the timestamp is sync'd with the STAT min and max, right?
> 
> The new type is done like:
> 
> 	{
> 		.name		= "delta",
> 		.type		= TRACEEVAL_TYPE_DELTA,
> 	}
> 
> Which will automatically be marked as STAT flag, and is set with:
> 
> 	TRACEEVAL_SET_DELTA(vals, delta, timestamp);
> 
> Is that what you are thinking about?

Yep, I think so.  I'll take a harder look at TRACEEVAL_TYPE_DELTA.
