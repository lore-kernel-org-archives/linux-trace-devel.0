Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4A76FB8
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:51:33 +0000 (UTC)
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3C8C9
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:51:30 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-7a27254cd12so6524039f.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696279890; x=1696884690; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DaOYaSmJwH6aW7hDzldld0QE8t6Iu4bdaQTrAvsjd/o=;
        b=1CRFffUNzwoUhngwx4E8R2sQbd0Yp4QzWLwXXwxreMCLl1TcmvJBdqaj+Qcmr0aXUX
         gkaRBnWqlKZDeKyeiW3VG4sx9bQi1bhAV+SqFu/ez9SFOeiEaK3zywIT5ZRDIbCQDmKC
         EOJLnpDtL+CtGeEqmhUVy8V9SLbksaiIe1J65Cq6+Qe/0LEc0V3cv+Z6rli72yM0RGuY
         6tV5/m6jfaQ8uBLA1x9dD9BJgwebjf6Sw4aYn2118WdO2sXMevlhmMou/Ln4H/OBSGW4
         N3z0X0NUjIQ2Dtk5K6X/b4hmm6JObwTvxRS47Rax0Nn662gkzKrbB0ciasRUYr0K565T
         ru4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696279890; x=1696884690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaOYaSmJwH6aW7hDzldld0QE8t6Iu4bdaQTrAvsjd/o=;
        b=k2dbQd2KE64++cU9SRWdbYO6cxHCUGurj0CICTrut3WtoB/3WPY6FemHafUrCc1vYY
         mOGDpGsF6Mv+C1AkLfhHOq8nNQi9dMm3I9TJ7X/ryCWf8PIpGLEC0+fuHPCl2C7AkO/9
         hg5w/v2aKu+2kxGMgAnacv4s4ESXnNj+9bbweM3Ex+KyIKVFUUK23TJgCKRIDVJpdsK/
         h9VvSY3JTBFyGDYYy2F9r62SCEyZmfEGWlT2a9DWHgrkQSnEih6cH+Vu+fQb9cjj+Ih+
         scghsnw/o4vrMBpjn6G+I/Zbrnzuy5Q0q3VrSw7NMvKYYL7hNap45yL4K1QJjX4MhD4l
         zd9A==
X-Gm-Message-State: AOJu0YwfAYSPzvtQwr6VMuHT3/+ZnBpjSd7oeggGh0gsiL1OS5EJqeFc
	hyEwS+VUS369/nst+YDr4TjYvQ==
X-Google-Smtp-Source: AGHT+IH0hWBpNupM6jDzLXrvFXS85vvvxg35uCbi+NxgQfOLbpeTNGtp6SA+AGL8N40mJgN/1HU6Ow==
X-Received: by 2002:a5d:85c1:0:b0:795:bea:ae13 with SMTP id e1-20020a5d85c1000000b007950beaae13mr16043126ios.20.1696279890043;
        Mon, 02 Oct 2023 13:51:30 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id h8-20020a5ecb48000000b0078337cd3b3csm58739iok.54.2023.10.02.13.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 13:51:29 -0700 (PDT)
Date: Mon, 2 Oct 2023 14:51:26 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2] libtraceeval: Move traceeval-hist.h to traceeval.h
Message-ID: <20231002205126.GM1532181@google.com>
References: <20230929082240.21420a2a@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929082240.21420a2a@rorschach.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Sep 29, 2023 at 08:22:40AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Now that the API of the new histogram logic of libtraceeval is rather
> stable, we can now remove the old version and replace it with the new
> version. The traceeval-hist.h was just a tempory header until it was to
> a point that it should be the default. It now is at that point. Remove
> the old code of the histogram and use the new code.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
