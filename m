Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0A71F956
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 19:59:38 +0000 (UTC)
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EA293
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 12:59:36 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-3513c435465so345525ab.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 12:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696276776; x=1696881576; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hrJL9TfNTIRkLg5E2dd/zkv81CLbnK4bUhCJ1ueddOk=;
        b=uale/DD6FcmyTMVrIkPIANoKtaYqLYX9aGNXZFMDTWATFqqec4YBPuG/RK6Pv4mEzF
         HsVyXyFpeg3jyNdtaQrf2h+T3mVowMbHMsq1Yiq3NKIyyCIGQK0dIGHrx3//i5iWlQZo
         iS0seg19wKyavdrP6NdN/Y0zZ/ng+iBo6NbPRerh3H5KjD8Q8NbeK3GweOHRid61Md2a
         3iirsaWP2jGscYcDJXYPrffYHm4yTiDVcMMYKf3BVJGYYlTJlhFjAgrUbWbUCkBspl5l
         J7z6PIVjivrTv3JSvZKRTqRUkP9uZXKj40rir1nwEZ6SSMh3nokn3UiOyeb8f4oNMtRr
         bTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696276776; x=1696881576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrJL9TfNTIRkLg5E2dd/zkv81CLbnK4bUhCJ1ueddOk=;
        b=W0bnNUplGaR7+9v+lS3V/QYSK8w5FmMncwlNGTs3iMhw+ZvqJxmSSzGKNYgkI/KBkO
         ct7O9ovrmw/gk/7s17UVbykEv/9JziGT9P+Bj/U73syOx/jnlTCPtwM8+5OcVoltTjiM
         65SBA00gskm6Jh0x+NDLSSvLIKro5uAqW170HktGAaE4DmcEWVfHQ6ugAiWHd6DfdaGi
         wl7ZL2il3/mkfKkWohSiQBcTD7S7tMJ3cpzta4LHTB5ToMkNmLQpl+xJ0judsc9VHNVr
         3NAvFGtzC2lUTdHnMFfvaCpmE4GKtqYQYaTt5+uRKhYekE6RaGTkkTJhtAlSCr7UWzwx
         0Lmw==
X-Gm-Message-State: AOJu0Yz6UfKs+qwI2sYGNrrAsF6T5IVUsq5tO3tXx4Pc5qbbgv8xwJHn
	+cdfuE/p9/+iNguiCvay679+aQ==
X-Google-Smtp-Source: AGHT+IEiGPQTYa0m4+ry0qMRvG9EzZel7GKoeHhRpy5gF/nyc71CnNAXLth0cYrFbMkKNOD5LkeqgA==
X-Received: by 2002:a05:6e02:1d93:b0:351:2053:f4a with SMTP id h19-20020a056e021d9300b0035120530f4amr563167ila.3.1696276776185;
        Mon, 02 Oct 2023 12:59:36 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id f4-20020a02a804000000b00418a5e0e93esm7052767jaj.162.2023.10.02.12.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 12:59:35 -0700 (PDT)
Date: Mon, 2 Oct 2023 13:59:32 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 07/11] libtraceveal: Add type checks to traceeval_data
 vals and keys
Message-ID: <20231002195932.GE1532181@google.com>
References: <20230927123314.989589-1-rostedt@goodmis.org>
 <20230927123314.989589-8-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927123314.989589-8-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 08:33:10AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Now that the traceeval_data has a type, add checks to traceeval_insert()
> and traceveal_query() as well as traceeval_stat() to make sure the keys
> and vals match the types that were for the traceeval.
> 
> Which also caught a bug in task_eval.c display_process_stats().
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
