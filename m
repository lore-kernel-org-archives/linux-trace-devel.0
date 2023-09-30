Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4C833F6
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 20:32:56 +0000 (UTC)
Received: from smtpcmd0871.aruba.it (smtpcmd0871.aruba.it [62.149.156.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604C9C4
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 13:32:55 -0700 (PDT)
Received: from [192.168.50.162] ([146.241.127.78])
	by Aruba Outgoing Smtp  with ESMTPSA
	id mgdwqGl4aW2JpmgdwqBH3c; Sat, 30 Sep 2023 22:32:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1696105972; bh=xtzYe8dzBN1TpST1uGYQillZFEmqpTegVcIO9/Pm11Y=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=c+FMfKLvUn0xAKuTLOGA3d+hAEFemxstXQS+mccxqzhRLpvnusjFAkJ4dOCZL93fL
	 xxe70CqR1pOIL5HiLhSgoecF4swmQ6ArSRWPxY/fyvu5vYiDkyR/D3M+hoYr9nLxmQ
	 USnuWk1aEynpLI4RbZMPywG2K2/YWyi65jYd+Omw8eswYdoaECLvgTwjsvpoRIDi6b
	 gpV8QMJAjy4Ydinvnm78DNxYLAkKDKd1vDeARMo09bylzsQChNmyeDhGa2tjfmeQN/
	 oySQ3jNsFPdvnAPjKpw6jIeXDNgCu5GS89H/5b58+8QfTTPUJmBEC52BapOtXmPspp
	 GcTPhgr2miL5g==
Message-ID: <ce8cac08-58be-4221-b5ab-fde7f9aab2bd@benettiengineering.com>
Date: Sat, 30 Sep 2023 22:32:52 +0200
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
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
In-Reply-To: <20230930162825.4f8544c3@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfPqOgBTp4FPU0d63cQKzAmhZCA8oES+BWGiFxuDYagy8JK+PhJnGCrodLyzrhMQ7lpheESSEkjuj9KJyfiIkLG0uu2nfdnm3OICaOD8pQ6hUScMI/q0i
 cCdmFzFc6wvAfUYl5yjcT5w7cLrNBF/9ya1euIVVRfLOXewtnXcuq+pNopOhTtDxE9jOxq9ouZoKVGa8mEdYX1+T0/Q546/vNUwD0mOPFUKr12o8swZLXNR+
 aEJIlRI8JmKUl5g8TOxcs1ZjCiD/wltrOflx39gVnUI=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Steve,

On 30/09/23 22:28, Steven Rostedt wrote:
> On Sat, 30 Sep 2023 22:13:39 +0200
> Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:
> 
> Hi Giulio,
> 
> Thanks for the patch, but could you please add a change log to explain
> why this patch is needed? I'm not saying it isn't but I'd like to know
> the rational for disabling documentation.

Sure, same for libtracefs then.

Would it be possible to release a minor version after committing?
This is because I've updated libtraceevent, libtracefs and trace-cmd in
buildroot but without using meson due to asciidoc not found(in Buildroot
we never produce documentation for target).

So if you could release new versions of libtraceevent and libtracefs
after committing V2 patches I could bump in Buildroot and use meson
that is very clean compared to the actual Makefile custom build calls.

Going to send V2 patches in the meanwhile.

Best regards
-- 
Giulio Benetti
CEO&CTO@Benetti Engineering sas

> Thanks,
> 
> -- Steve
> 
> 
>> Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
>> ---
>>   meson.build       | 3 +++
>>   meson_options.txt | 2 ++
>>   2 files changed, 5 insertions(+)
>>
>> diff --git a/meson.build b/meson.build
>> index b61c873..9a18e02 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -45,6 +45,8 @@ if cunit_dep.found()
>>       subdir('utest')
>>   endif
>>   subdir('samples')
>> +
>> +if get_option('doc')
>>   subdir('Documentation')
>>   
>>   custom_target(
>> @@ -52,3 +54,4 @@ custom_target(
>>       output: 'docs',
>>       depends: [html, man],
>>       command: ['echo'])
>> +endif
>> diff --git a/meson_options.txt b/meson_options.txt
>> index b2294f6..9a40dad 100644
>> --- a/meson_options.txt
>> +++ b/meson_options.txt
>> @@ -16,3 +16,5 @@ option('man-bold-literal', type : 'boolean', value : false,
>>          description : 'enable bold literals')
>>   option('docbook-suppress-sp', type : 'boolean', value : false,
>>          description : 'docbook suppress sp')
>> +option('doc', type : 'boolean', value: true,
>> +       description : 'produce documentation')
> 

