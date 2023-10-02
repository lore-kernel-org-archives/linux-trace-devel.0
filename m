Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76BA1D54F
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 18:43:33 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212E6C9
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 11:43:32 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9b2a3fd5764so3706666b.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 11:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696272210; x=1696877010; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wfiq6vHGsqqHnrsRG/Dz9qMy9bTrd1JMUnOOQOqB0oM=;
        b=BXCr1qsMaRgwb3R06HMMI7d/dkCuGK7izzxfmupuSJOtn1h54lXdNtUAahfetarfO5
         vTBtbW0F7yf3TFg63XIZKHXYdJO7yWM++EB49uEYliK+MBwRNBmvX2WAzGX/1vszGcX4
         f/n5PrSBF5xKrkijlwQdku0FMum/mV7lZot7l7F0d+I+npWbS/nQKyvuZXPp+Lybsp/V
         MiIyehRwJ7sFWRrM3YCEtWDXGXSdjA50v4Z0UzirqqjpCHvUkCQ661bPT77JuhOnIFp6
         9h/lWE2QsjTysLRLzAD7reAo1UFJ5QsMRBAekI+XSnJB62VLNBTvOSwSRkenhV8b3mqd
         6K4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696272210; x=1696877010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wfiq6vHGsqqHnrsRG/Dz9qMy9bTrd1JMUnOOQOqB0oM=;
        b=Pp3BB9jSIgXxhoUKkeP4K0nBxPlnu8y8oh77qt/XdiY8lscd4eZ/OCRsuW5h4yNx6x
         egzxqZyqNcG9gDrAiCliHEzAagcOQTdWDKtwBvsw57726tKn8zSSrpZnfXqiPoWwTzQt
         BsjniV3+oY5q6tyzRc2gxFMVq55/fHlK9K99juABuXu/EPLuRJPAL53Po9mh8UTkhE8H
         dRte32YAhw3QgoWoozNg3Ba1UIW5k9lrE/kNoMnzVFhN8FLzUwemvhOsBaF+qSmXmoWs
         2v89A0Xi520NmoI8tfQNivhTvLHR27Eq2mwv2vqDZ/el+33PQstHCgim2iutYhcpI2aM
         jLcQ==
X-Gm-Message-State: AOJu0YwDXGbzzMpGfgCaUh9mCcWDnfW6ob2r3aJudV4tIp4d23ipo/7/
	txDlts1l2s9F2NXBvnd2CKg=
X-Google-Smtp-Source: AGHT+IES91Ow7Ytdr0FbJLo1VSv4hUi+YoC64cjrE7GmSjxKpSWPYQywciBk2Os9pcOMoNjb8sqoxQ==
X-Received: by 2002:a17:906:519d:b0:9a1:e293:9882 with SMTP id y29-20020a170906519d00b009a1e2939882mr12869837ejk.63.1696272210237;
        Mon, 02 Oct 2023 11:43:30 -0700 (PDT)
Received: from [192.168.0.107] (78-154-14-170.ip.btc-net.bg. [78.154.14.170])
        by smtp.gmail.com with ESMTPSA id bu24-20020a170906a15800b0098669cc16b2sm17261746ejb.83.2023.10.02.11.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 11:43:29 -0700 (PDT)
Message-ID: <d39af1f0-9e05-7c57-3248-4f5f16801e4b@gmail.com>
Date: Mon, 2 Oct 2023 21:43:28 +0300
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Kernelshark: migrate to Qt 6
To: Steven Rostedt <rostedt@goodmis.org>,
 Jerome Marchand <jmarchan@redhat.com>
Cc: linux-trace-devel@vger.kernel.org
References: <9085cbc1-7bf2-38a2-4e4f-1c43c760ce97@redhat.com>
 <20231002140136.6ae97dfc@gandalf.local.home>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20231002140136.6ae97dfc@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 10/2/23 21:01, Steven Rostedt wrote:
> On Mon, 2 Oct 2023 14:22:58 +0200
> Jerome Marchand <jmarchan@redhat.com> wrote:
> 
>> Hi,
>>
>> Qt 5 is reaching end-of-life and Qt 5.15 appears to be the last Qt 5
>> version. Is there any plan to port kernelshark to Qt 6?
>>
>> I have no experience with Qt devel, but it seems that some effort has
>> been made to keep the migration easy:
>> https://doc.qt.io/qt-6/portingguide.html
>> https://www.qt.io/blog/porting-from-qt-5-to-qt-6-using-qt5compat-library
>>
> 
> Thanks for notifying us.
Thanks a lot! I wasn't aware of this.

> 
> Yordan, do you have any time to make the transition to Qt 6?

Yes, I will take care. It may take some time, but I geus it is not urgent.

cheers,
Y.

> 
> -- Steve
> 
