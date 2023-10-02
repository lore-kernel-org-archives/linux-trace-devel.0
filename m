Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE531D53B
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:07:12 +0000 (UTC)
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8161B8
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:07:11 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-79fd60f40ebso3196639f.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696277231; x=1696882031; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OK5El5kUK6813Blg16UYBVEyJ6+3og/ugN0HoZ2dWp0=;
        b=yxyYyTNPSdiREuFmC3WcFvVK+3DvUxKMb0S8absTO5D6bPvUQZ6o1P8B+iCFIBwQap
         knV1KqdIsjYme2cmvFmye7ng3bOuvF4U05jl3bnwgGcwBKj1buJoujtu3JDeHg+n0IQO
         /5/9Gbvp2VPBYBsJ2ZgmQT2Adfrle1EqE95d/GI9HH8a5BLiB+H6fpV1iyBO5/+o0Mgu
         1kr78nIIix31oFUzJxfGrNuJlzfXnPqT98N4JlQky9GaQI8deyO/a7LhYohwyPdl7Anu
         OvhcGabOZ16eM64FbQGj1P4vK71NOlPIAoNvTThXmlR7woTrZvFzcfM0pi6iRAHLT7iY
         NAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696277231; x=1696882031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OK5El5kUK6813Blg16UYBVEyJ6+3og/ugN0HoZ2dWp0=;
        b=Qt7Oxh6F0bMS2V/H6L6bKy7nBED6Ghzce7aBRBjZiAzww0bI0qGRBr2NkoKOIV3buP
         Grl5NV9VKa3BC2pcxrtRX5XtUOpZBTu0B1qL2wLABxguYJsgjoP+o+eH3LX71smnCO9Z
         bjg1UTY2LMuQNECduiQubVvZ619GMZhKQ4RF/fp6GOU0wPDc0EJZ5UvloaI6o57XLN6t
         acXt1ctF1WzSZGTgguFFxMQFnDhA/UfAd3PNDrxuUF0Wb0+otr+nfRZc7Dy/x6uv2V1P
         zLcKKl/MoIf2Eou+P3PIQs+oVSM6y2c+6JMNfh6O98NPI6ZP+YTyP9YKFXA9pS6QcMTL
         SRNw==
X-Gm-Message-State: AOJu0YyTgmjkAGpQgsPuOyapLkaVCXZTZ7I0k8inzuIv2bxNhGHtsCec
	+Uxkh1fK1HRpxdKQhiNGf4rvmw==
X-Google-Smtp-Source: AGHT+IELIkzTWNgtQpCOdf9z4hxFYhxtaTCbKR85XDL8H02XK1Amp5JvB1XDgl31QXUqh6VMlRUB9Q==
X-Received: by 2002:a05:6602:1655:b0:794:e98c:30c9 with SMTP id y21-20020a056602165500b00794e98c30c9mr589708iow.1.1696277230991;
        Mon, 02 Oct 2023 13:07:10 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id el9-20020a0566384d8900b00439d4db47b6sm6891604jab.39.2023.10.02.13.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 13:07:10 -0700 (PDT)
Date: Mon, 2 Oct 2023 14:07:07 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 10/11] libtraceeval: Make traceeval_stat() check size
 of keys array
Message-ID: <20231002200707.GG1532181@google.com>
References: <20230927123314.989589-1-rostedt@goodmis.org>
 <20230927123314.989589-11-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927123314.989589-11-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 08:33:13AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Make traceeval_stat() into a macro to pass in the size of the keys
> array, and rename the function to traceeval_stat_size() that now takes
> the size of the keys array.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
