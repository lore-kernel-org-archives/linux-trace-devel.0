Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5855A347A2
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 15:29:33 +0000 (UTC)
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F15283
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 08:29:32 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-79fa2dbd793so41834639f.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Oct 2023 08:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696346971; x=1696951771; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HibaJTk6wT8/FSvrRyiym/5E033K9jcw83X5E+46tx0=;
        b=koaRmtniiwM3g0RFsSNeWNhlRi2WFbDyvYlAdEL+4bN3cHLW/lEkdFq5rc47v1Hwg1
         UoROVi9j+5Q++1l2gebJhPhA/L7x76E7pQXZbLwRrUhGU8/yoIATQlmljHw45MDKhFgp
         zBZLQxbA6NXEVbwlv18dq4e+JssjUXh3wwKepnyKXqUHpy86/khEun93oLFh4Sez2OhL
         wKT7ZSwBKc5HPJLyQsJ3IOdWQai4DSYEEtgocsT4qqhp05qVEqPhWkGW7fK7DBofg9xY
         IK6AEYFHdIAWeSv1M4WU6yVFwJCTHUY2lRr2feWM1pYjwpDJeM+Pvie6DSdfapLlS0NL
         QioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696346971; x=1696951771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HibaJTk6wT8/FSvrRyiym/5E033K9jcw83X5E+46tx0=;
        b=ke/zJkc3MKFToIVd2klG9D6mVccohN9J1TJgGDy31hq9EtfpAGsmVLoO5P7pvXAjf4
         iZs+LkKx2+1fGYFjbgJL/0X9qyZFEfiBTYYuF/cn0V/vLkfb0fRPRgxoBCY9A+4vjmDi
         e9pa/BINBI+6QVa5b9/Zmcqd6as3hBy6zRFvw2bxFK5mYCnshmOBK68saVwKOCjvFDWW
         JB1Q8PV6WRELg4OMGz91EJ84nV3/PLrQuXN+t9jYp3qODtkJl9FBDZaSpmOJaSPJrDUA
         VtdNYgp1vGxFH5qI4e3ODv5z3N2hlaPsXHIoOX/wB0Hk7L/4aEnMxKeQnT9NYNWhdGNR
         Cuwg==
X-Gm-Message-State: AOJu0YxwgQpYEg2yeFdWm99Rt20797SeSRuGZtI+ykJZxqDZUCqCGDMs
	7eu2u32mZM3K+00Cw4c4Dv03JQ==
X-Google-Smtp-Source: AGHT+IEWTFHKENGtdbJIoDMQAoL8CwyX4EdVK4cacnqbXcWpuwysbZTXFcFFeLGxXzUxbdefu1t1Jg==
X-Received: by 2002:a92:c546:0:b0:351:a18:51bf with SMTP id a6-20020a92c546000000b003510a1851bfmr17942662ilj.13.1696346971440;
        Tue, 03 Oct 2023 08:29:31 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:d5ff:6f50:bbbd:a922])
        by smtp.gmail.com with ESMTPSA id i18-20020a02c612000000b0043a1e2ffdd8sm410138jan.33.2023.10.03.08.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 08:29:31 -0700 (PDT)
Date: Tue, 3 Oct 2023 09:29:27 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Ross Zwisler <zwisler@chromium.org>
Subject: Re: [PATCH v2] traceeval: Add way to extract the number of elements
Message-ID: <20231003152927.GB1935474@google.com>
References: <20231003094206.2e6a5fd6@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003094206.2e6a5fd6@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Oct 03, 2023 at 09:42:06AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add traceeval_count() that will return the number of elements in the
> traceeval. This can be useful for allocating an array to store the
> elements. By getting the count, the allocation can be done first and
> then iterated to load the elements into the array.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
