Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926D8E560
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:45:12 +0000 (UTC)
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19817BF
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:45:11 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-35135b79b6aso675645ab.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696279510; x=1696884310; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+6SJI3mSv2HSomC3j5HOYqZ2icjRyZMgOxB69wx9h/8=;
        b=PTd1+J+RFEXEhAJP0y24r2pG0xXRsMtWPyV53DVRBr2Muwc423kJPTU+0/jEctozpn
         E9OcdMVgIO4Du9FKuuYNoskbC2pkd9GIPIskc5/D+q/nz21/pWUGXjii4zAQAffzNTi+
         lOnW78ym9zs1L5KhHoiSfNtQUSeQ2Ms67sAr47ENBBenUP6DdH+zNCzYcBt/sDFzX9Gt
         5QloSfjUp+fmC3DvIv4+exsT58hpeDiyfc/sE1OkS2zePSrjbTVauzdEdsPYxbEvOcHd
         miOaElq6ozu32IUPA/nymm8taS79mfeSdsbBSKYZ/+Izx0gQSpbSAzj6mA6YkyarAjq4
         snvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696279510; x=1696884310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+6SJI3mSv2HSomC3j5HOYqZ2icjRyZMgOxB69wx9h/8=;
        b=EVxsvsp3AHyHXhLl2M/xr4w+eVx1BkoYfdRcogOz3kK0Lm83I3wu7waSfMAy+nx3o1
         iQh5IaZmx4urX6tfjOGuMD2rDuntFbFDKW22Yk2vFyxLm5/Tw9IAt7fxmPw18QNFeq3o
         mAa9ZLCJiPoUBJp3QKXs9GkiYX0HzKSMUVGcyIQP1JZRPx5K7Tfp6nPRZbfYqCjaJQTE
         54HRyJmX83zHPVb/yFSLnDvmozw/PhzCM9TF6jcWL8oOrg6l9f7XD4YjigKoRxDizwNQ
         Lj0DSOfUhKxn1BHIfVENM/Ik+oGmGSpZ7myKeYXmDbxNKYjWpqGDqAO4klnCNwl19EGr
         6Dtw==
X-Gm-Message-State: AOJu0YzXodLTSqpaZSQp/7pzBK+/P630ZlX6j7gAIKDhhJLgaMAHdDIF
	LbJxKs1waG62wvYeAWALr+od0Q==
X-Google-Smtp-Source: AGHT+IFOgTSOcujOmpH15OjsbDRyQeWKemKwmhvq3zPtJSBZpOZ1VHR9emEVlwGqRklhT2FN4iJKPA==
X-Received: by 2002:a05:6e02:df2:b0:351:1d53:c770 with SMTP id m18-20020a056e020df200b003511d53c770mr11613064ilj.5.1696279510257;
        Mon, 02 Oct 2023 13:45:10 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id t13-20020a92c90d000000b00350e63bd1ebsm3988907ilp.70.2023.10.02.13.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 13:45:09 -0700 (PDT)
Date: Mon, 2 Oct 2023 14:45:07 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2] libtraceeval: Fix traceeval_insert() macro for NULL
 vals
Message-ID: <20231002204507.GL1532181@google.com>
References: <20230929051304.7b157905@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929051304.7b157905@rorschach.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Sep 29, 2023 at 05:13:04AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If the vals is NULL (which is valid), the traceeval_insert() macro calls
> traceeval_insert_size() with sizeof(vals)/sizeof(vals[0]) to get the
> number of vals in the array. But this does not make sense with a NULL
> value. Check for NULL and if vals is NULL then pass in zero.
> 
> Cc: Ross Zwisler <zwisler@google.com>
> Cc: Stevie Alvarez <stevie.6strings@gmail.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
