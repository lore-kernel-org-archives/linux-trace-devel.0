Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55902106
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 20:42:21 +0000 (UTC)
Received: from smtpcmd0872.aruba.it (smtpcmd0872.aruba.it [62.149.156.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFE9C4
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 13:42:20 -0700 (PDT)
Received: from [192.168.50.162] ([146.241.127.78])
	by Aruba Outgoing Smtp  with ESMTPSA
	id mgn4qGpJpW2Jpmgn4qBI9Y; Sat, 30 Sep 2023 22:42:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1696106538; bh=XrRTUkcfXww7v9lE6IYCVGersW7pu+Nz/AWprLz7MaU=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=FLnRuNn/sayjzSfAU8KnMXkEhLSSQWzds6N5vHpqF0V+oV1GdNUq40MpA7MIiNMCp
	 ZI04ul+o/nMVmnn52mCxe5jGJKNF0rHcUyaPp933HbUWl4MsFtjM7GONmroUlkUQNX
	 n0+4TZ47x9b8ZiwRzxtkYI73ZrIAdp6vhHgcGjlSwmVnZ/meplneZMGXVUN0e9TGuh
	 qoegbo69yw/q+4/v88NRCRE3SX/Fb3GbxYUCpx4qOwObpkGZoU6JBa1KqFDrf2VGYq
	 kQSNpKYCxZcs2yeUrSs/9aWoLsAdBcHI25/mtyT1vjq+8NCctt4Vrm9fmEPA7MuNTR
	 t5h0BzdJ4ZKDw==
Message-ID: <92043dd1-9327-4370-a81b-d84aa4351a5c@benettiengineering.com>
Date: Sat, 30 Sep 2023 22:42:18 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtraceevent: add option to disable documentation
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20230930201339.2525344-1-giulio.benetti@benettiengineering.com>
 <20230930162825.4f8544c3@rorschach.local.home>
 <ce8cac08-58be-4221-b5ab-fde7f9aab2bd@benettiengineering.com>
 <20230930163900.152d49fd@rorschach.local.home>
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
In-Reply-To: <20230930163900.152d49fd@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfIrLyNC37bxrN/wvJp8orit7zWLeVpoBiSt8OWH5qWmmwEG7CgrkryRIDaqNwwjteK7bXOKb1QTstr3ljdUgLEX16E1ZBIQmbRKtcFuXj47zdT1Jha3U
 +J+QXYLhUuSaieB3ZEpXmHq6Rwfu1cA3WID7esDMDEnXHm4LatXfyrL2sHkqFBIM2tipHmklBTlIhwlVu7oUkUjV7aaq/NNkQdMEUZJOUiinMDZH4Xq6K1/l
 NpgPDvSTb9bITOISvRjiYFQr58KSYbiExjFM+1baPJo=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30/09/23 22:39, Steven Rostedt wrote:
> On Sat, 30 Sep 2023 22:32:52 +0200
> Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:
> 
>> Hi Steve,
>>
>> On 30/09/23 22:28, Steven Rostedt wrote:
>>> On Sat, 30 Sep 2023 22:13:39 +0200
>>> Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:
>>>
>>> Hi Giulio,
>>>
>>> Thanks for the patch, but could you please add a change log to explain
>>> why this patch is needed? I'm not saying it isn't but I'd like to know
>>> the rational for disabling documentation.
>>
>> Sure, same for libtracefs then.
>>
>> Would it be possible to release a minor version after committing?
>> This is because I've updated libtraceevent, libtracefs and trace-cmd in
>> buildroot but without using meson due to asciidoc not found(in Buildroot
>> we never produce documentation for target).
> 
> Sure, it's time for me to start working on the user space libraries
> again anyway (I toggle my time between the kernel and user space
> tracing).

Awesome!

>>
>> So if you could release new versions of libtraceevent and libtracefs
>> after committing V2 patches I could bump in Buildroot and use meson
>> that is very clean compared to the actual Makefile custom build calls.
>>
>> Going to send V2 patches in the meanwhile.
>>
>> Best regards
> 
> Appreciated!
> 
> -- Steve

Kind regards
-- 
Giulio Benetti
CEO&CTO@Benetti Engineering sas
