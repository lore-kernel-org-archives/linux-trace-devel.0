Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CF414275
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 12:23:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CE1A6
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 05:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696249392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Sy+wt2GFE2Np++NRZTLPoJlvjKsGHLfmzCrSuKUx3no=;
	b=VjRG9Q2nrWb0BooK0J2aZ6ni/CAdRZNpKloV0njS7O3kULRAioIbfIbnA/tKwc/UyWysHS
	DzP7SooSfscWLgXNtqwzOrQ+qRsZA8jMG+68TdIT9rmbQbLdrTbzKL43BUN7FUTWgGDwwr
	z/ly4SAhghm8j8xXkWkDF2wHpeDLei8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-qnBWmUxIMVKPa__6xCjSfA-1; Mon, 02 Oct 2023 08:23:01 -0400
X-MC-Unique: qnBWmUxIMVKPa__6xCjSfA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9a1cf3e6c04so1445696566b.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 05:23:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696249379; x=1696854179;
        h=content-transfer-encoding:subject:from:cc:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Sy+wt2GFE2Np++NRZTLPoJlvjKsGHLfmzCrSuKUx3no=;
        b=ZO1/BMexFNPLi9a2Aum2uu4Svt9/FnUgpDuLLdXXq0/Uc6I0VHedAz7O0Xqyd+G8f5
         PQObR2mKv8KbnyLl9cIcFc9rcZQdcdgMT7uEcc5HJ7kbT0epLW4Wlut41FWyZWU9Mry1
         Jy2kmOEA8Um9K+kcLSRDn0DZAG+6YjN08Y7xH7rCkn6n/tDzkU9sBrCCwPuQuG9XX+xd
         So/ddvMxTaM2cvVj62KQQjh5/9JP0V5bqZjN7sj71k8CWpk/AjMAh5lyGhFGFydhHg9/
         qrwPzLNeiopXX7NzwYYOKnHXBkxnI5X5Y9CchHS6jAWDuLluBJVmPNTF1lx7EqpB0mUN
         MRjw==
X-Gm-Message-State: AOJu0YwNDSQ454Bl0fi8gFhemc6/UETl1+OF6Yf+s2LR1lV3yDtQMfME
	xMMZ0fGc3z93l6g1R3bweNDjnjr6vc3RJzv/2ZfXSOVNHw2DytCFA2oPrDh9oGhvTlyao2Tu2/M
	yS7lWtqXOEtsgSv0OtmSCmX7gZnccvi4AQzyLzifkjO9pXbHjEXZ3PID/4ZEPSCLC2OXLJf43vS
	VeuvzdpgBhyLsnLvk=
X-Received: by 2002:a17:906:292a:b0:9a5:c9a8:1816 with SMTP id v10-20020a170906292a00b009a5c9a81816mr1235932ejd.58.1696249379689;
        Mon, 02 Oct 2023 05:22:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1MKHpTSskVrt3COyCtKAxs0vwzxN3qRuTwJgPTBNpXjozFpPaojVWt8+oGMcgdAiKWo88jg==
X-Received: by 2002:a17:906:292a:b0:9a5:c9a8:1816 with SMTP id v10-20020a170906292a00b009a5c9a81816mr1235917ejd.58.1696249379401;
        Mon, 02 Oct 2023 05:22:59 -0700 (PDT)
Received: from [10.202.149.147] (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id j25-20020a170906255900b0099bcf1c07c6sm16882763ejb.138.2023.10.02.05.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 05:22:59 -0700 (PDT)
Message-ID: <9085cbc1-7bf2-38a2-4e4f-1c43c760ce97@redhat.com>
Date: Mon, 2 Oct 2023 14:22:58 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: linux-trace-devel@vger.kernel.org
Content-Language: en-US
Cc: Yordan Karadzhov <y.karadz@gmail.com>
From: Jerome Marchand <jmarchan@redhat.com>
Subject: Kernelshark: migrate to Qt 6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Qt 5 is reaching end-of-life and Qt 5.15 appears to be the last Qt 5 
version. Is there any plan to port kernelshark to Qt 6?

I have no experience with Qt devel, but it seems that some effort has 
been made to keep the migration easy:
https://doc.qt.io/qt-6/portingguide.html
https://www.qt.io/blog/porting-from-qt-5-to-qt-6-using-qt5compat-library

Thanks,
Jerome

