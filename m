Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD61F1F939
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:18:04 +0000 (UTC)
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7D8B8
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:18:03 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-79545e141c7so4081139f.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696277883; x=1696882683; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g0PbWMQjUSgt5T1g0jb1IfQQ+oY7Rh0WgaMDVvTvrPg=;
        b=0IOkrDxD0OV3U/3OEp318lzrdLh0B2cI7Lzk3c6rcY7Be1kydbO9LSkM+GDpKk3Sjc
         DJTjnYcgw3XoxhyCKtf7wvq4eObqRvGpzYvJvNDO0OsG3UvLPyOSg+bvNNWfw0HHGxP5
         WdRgPmkSRpjLFxHZ1+o/tZLJNhDwmAvm3jMrlOBDQR6PHdUXaPDYm32o1r4qKOdSaICk
         g7WiNHAn5uahsxW220HfWZw6Y8vYaOtwbftkZ97WKO/xp1u9SWuGMRQsBhOm00jb4MnO
         9oeb+qIPixo7/5+zRd6cmIuSQsBVXWuACkP5KHHselnQ2mYL17GUtHZb6f1Muv0XVGM5
         b3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696277883; x=1696882683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0PbWMQjUSgt5T1g0jb1IfQQ+oY7Rh0WgaMDVvTvrPg=;
        b=HpzTaUSMsM3rtYbiMj3tzdoBVrFq1eZfCCmt85whRgKDI52kcBS6ygR1PcS69+iYnB
         pkbHpmxDP23sBH6qzoMwTIsjxylNsAt7raXhtseqYQ1ynwRgs/bK8VbjWdUbU8F/pQDm
         bC6u+nuBtPaP/dIoG5SNGI8Ok+lRUu66Da3C3xWTHAPdDH1YNjWz/SD7JwVaFIpKKKT6
         KfRc/nK0USDaRKg+yaGuZLZIgczXaLL1w8roTemDdBkoat39FOhJEkgdq9Menihv5Bu2
         4NSeRmJt/RzsIfwXOAjPGEp2TVax1mZTIB9BH8DfejNky2gqsd3CVv9bJmUATr1Kk+yj
         2Ddw==
X-Gm-Message-State: AOJu0YzZoGtJbugqNKs+ugTnTUzhaAgsxY1wgJxYA3t5DnbxBeEyJkEA
	lad/h1U2lf8CbapJNykN1P4H543CvuPiY5RN0VqGig==
X-Google-Smtp-Source: AGHT+IHjdfdhtGyjDq8A6doSGazz+yL2qjpVX+2ipxpmBR1jKKKTcrE+4sQzGVBBudsE1oYrMUsBkQ==
X-Received: by 2002:a6b:14c4:0:b0:790:aed5:d0b0 with SMTP id 187-20020a6b14c4000000b00790aed5d0b0mr657663iou.0.1696277882867;
        Mon, 02 Oct 2023 13:18:02 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id b19-20020a5ea713000000b0079fe8ec6736sm40162iod.55.2023.10.02.13.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 13:18:02 -0700 (PDT)
Date: Mon, 2 Oct 2023 14:17:59 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH] libtraceveal: Remove TRACEEVAL_TYPE_DYNAMIC
Message-ID: <20231002201759.GI1532181@google.com>
References: <20230927090417.6cd02a37@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927090417.6cd02a37@rorschach.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 09:04:17AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> There currently is not a known use case for the traceeval_dynamic type.
> Remove it until there is one.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
