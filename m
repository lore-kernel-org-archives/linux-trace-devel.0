Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC9A249ED
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 22:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1iYdtJIV"
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0DFAF
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 15:21:05 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3512efed950so1151495ab.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 15:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697062864; x=1697667664; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JMlgrV0SBKYPyRV3Ikc5hKhGQD/Jfn91CEyeMSHPZyM=;
        b=1iYdtJIVU9M62WdctwBRgMjBiuM0f8/nQDVRkwPamlnINUwrIAvEsba2q7a15DScDR
         DakuW6MXmn1DPQyr0H2HHeBogfQuPJNWNRHXU+CWwLp4jLm++XAVrm5wPVa/vKLNBZYH
         IH50qyuFq5v2/WJYzIezwe7zyhA8p8BblNgwV66MOQmJxUs+HVEWw4XreMnVaNtqYNQj
         ZWdpm2OIGntaBvb8MrKh0bCRfA/1U1S9fINm0MOACn8oXlRBEXjH19Jt4W34/KbEPXW1
         SqtoVwNu33r/Sr6TFHue2DtCdCnuDbnzSR6SAAfuVMYrkoaLoiGAR4J1SCzoLPZXdhMP
         j50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697062864; x=1697667664;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMlgrV0SBKYPyRV3Ikc5hKhGQD/Jfn91CEyeMSHPZyM=;
        b=v68cVdUaNlMvJkeHrmSI5nD0CPmQwj1dx1Pfr1l6fuyFLU2jZ3v9ZZw8hRS7ekSEML
         MVSwDGWg1QNhRRII0xwhph464ntUkuXU3mhAkA5Y2a2Z+hmhU8yhJiC5o0qln5aERxEQ
         2KdiogGbGlXvD6/P8J7w+FRN3aNN3PfCz8iqhaLL68d94yz6v0iax1ftiTdh3NQbC66r
         hNvfHNDEkQuZCy0fIXRCE8hxCVd1vzJ3+Pi679agu6fmq8AttfjQvDivZJn7IOBCCfCm
         sM6TqdRqUna6dfxBqPU9nYJPb6EWLvyO6WVkfwCtsleY2+yainV5a/kfCRLRR6z+lnpi
         hJHw==
X-Gm-Message-State: AOJu0YyZYvvx9KsD/XZG8u/OZ1KPlwFiDmZxP8G99QZpBK/6ELyBtv9h
	bv+XCDEjMznWxANq19o1AsBleaJRYEMZNfEtwMYulQ==
X-Google-Smtp-Source: AGHT+IH1PPbgMyp5vZcDczJ8aDxmu9FH60GQ8Zd6TnooU2dLJ1KOPxkaNLHVRGOCzwDIpV8vXND6DA==
X-Received: by 2002:a5e:c813:0:b0:795:c6f:59ff with SMTP id y19-20020a5ec813000000b007950c6f59ffmr25675861iol.17.1697062864512;
        Wed, 11 Oct 2023 15:21:04 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:6fb5:b607:f4ac:85])
        by smtp.gmail.com with ESMTPSA id v16-20020a02cbb0000000b0042b1061c6a8sm3671948jap.84.2023.10.11.15.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 15:21:04 -0700 (PDT)
Date: Wed, 11 Oct 2023 16:21:00 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtraceeval: Add traceeval_stat_max/min_timestamp() API
Message-ID: <20231011222100.GA94116@google.com>
References: <20231005181448.176e9563@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231005181448.176e9563@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Oct 05, 2023 at 06:14:48PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If a value field is flagged as a TIMESTAMP, and another field is flagged
> as a STAT, have the statistics for the STAT field automatically keep track
> of when the max and min happened (what the TIMESTAMP field was at those
> instances).

I'm confused as to why we have TRACEEVAL_FL_TIMESTAMP and a separate data
entry with that flag, instead of only storing the timestamp in the entry
metadata, as we do with the other STATs?

From the description above where we have one TIMESTAMP and one STAT, I would
expect to see structures defined like this
(from [PATCH v2] libtraceeval: Add wake-lat sample code):

+struct traceeval_type sched_vals[] = {
+       {
+               .name           = "timestamp",
+               .flags          = TRACEEVAL_FL_TIMESTAMP,
+               .type           = TRACEEVAL_TYPE_NUMBER_64,
+       },
+       {
+               .name           = "delta",
+               .flags          = TRACEEVAL_FL_STAT,
+               .type           = TRACEEVAL_TYPE_NUMBER_64,
+       }

where the timestamp is sync'd with the STAT min and max, right?

But we also have this:

+struct traceeval_type wakeup_vals[] = {
+       {
+               .name           = "timestamp",
+               .flags          = TRACEEVAL_FL_TIMESTAMP,
+               .type           = TRACEEVAL_TYPE_NUMBER_64,
+       }
+};

in a structure that doesn't have a corresponding STAT field?  This is also
confusing to me because we need to keep 2 values (min and max TS), but this
only holds one?

The timestamp is already stored independently in the stat metadata in
struct traceeval_stat:

>  struct traceeval_stat {
>  	unsigned long long	max;
> +	unsigned long long	max_ts;
>  	unsigned long long	min;
> +	unsigned long long	min_ts;
>  	unsigned long long	total;
>  	unsigned long long	std;
>  	size_t			count;

which I think is enough?

It seems like instead we really want our two flags to be:

TRACEEVAL_FL_STAT
and
TRACEEVAL_FL_STAT_TS

where the first just keeps the normal stats (min, max, average, std. dev, etc)
and the second does all that plus timestamps for min and max?

This would also allow you to keep min and max stats independently for multiple
entries in a single structure, i.e.:

struct traceeval_type task_vals[] = {
       {
               .name           = "wake_delay",
               .flags          = TRACEEVAL_FL_STAT_TS,
               .type           = TRACEEVAL_TYPE_NUMBER_64,
       },
       {
               .name           = "runtime",
               .flags          = TRACEEVAL_FL_STAT_TS,
               .type           = TRACEEVAL_TYPE_NUMBER_64,
       }
};

which I don't think is possible under the current scheme?

What am I missing?
