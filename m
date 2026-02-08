Received: from smtpdh20-2.aruba.it (smtpdh20-2.aruba.it [62.149.155.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21EF2D7DDD
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Feb 2026 21:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770587255; cv=none; b=vFIB/6HD84EKwfMW9tBkXT5DOgmTQuZ7SlWSEOkULlSFQV1rPJSJGSD+h/Mfbo3dborWafQU5G1faWl8G1lYcMypLwt3pUvZ9+I++nK3wOg8nLPe9O9WuUg+KFd0rXTmhp8BwzTeqG1gijfn1xuBlJA2+QiUn6KbYuTUUl9aKjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770587255; c=relaxed/simple;
	bh=wI4csQ+Z+ljidjay1Jg3/v4a4l5UREsWJEM8i+hsuGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfW3dRoWlQ/m/FyTDAaTIvosOwFIij0HqAc7ISoBH9HIIh7AMtZL2kF6SoEVZm4Ov8NWazLqgujr8P2XO0EvR0KIkHyp0T4r6nEStXEqsrN1L1fg7DkL1vPEmop1cE6r3TnZV+jiNA1KuHf5NZXUUVReaMscrfuj8vwwUaOb3Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com; spf=pass smtp.mailfrom=benettiengineering.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=XSxQO0ZA; arc=none smtp.client-ip=62.149.155.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="XSxQO0ZA"
Received: from [192.168.50.134] ([84.33.84.190])
	by Aruba SMTP with ESMTPSA
	id pCZsvnSiTgZB2pCZsvzIsh; Sun, 08 Feb 2026 22:44:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1770587064; bh=wI4csQ+Z+ljidjay1Jg3/v4a4l5UREsWJEM8i+hsuGI=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=XSxQO0ZASPyj/8ZM92LWvI4VPNMRm1GECMPAbQQiY7/5M63kaUhd3t9W/FJXRkmPh
	 SsCsZIjqbrfLgRxKlF+6BTeGMKOTUvagV1JRnmkEyxtM430EEgokFCwCkg4OeQxMHJ
	 8R5YRSNWON2lmGANCoQf1hUp911B+GmmRPxZRwvakIm/jO4BPvDScc9AU0ViVQ/Q9r
	 JtsPjdolXpFyxGGSQvFW07PHrf/BjcIovA8osVqYOgAL81kvbEZor78o7jdMugadL0
	 aOMWd+7ctkKvz0EM34FI8ZpmHeIVCYa+AMfrhP2mJNkmVkeAbqnMz7b5hMV0eqRqGr
	 REIb26y9f4Bbw==
Message-ID: <1624899e-97c3-483e-b859-2f6184458e5f@benettiengineering.com>
Date: Sun, 8 Feb 2026 22:44:24 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Build failure bft for trace-cmd and libtraceevent
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <5984db8a-a93a-4efc-9b81-c87140d38042@benettiengineering.com>
 <20260208163211.63e645cb@robin>
Content-Language: en-US
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
In-Reply-To: <20260208163211.63e645cb@robin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfDxYyA67A3UPUZe9JZuD7LwzYSCEjwF55iZI56K6qp9gTNzbb4pZw0vdsjgro88urMbATFk80a3x1Rxor3bgnL4Gve4lHuo/WPAmgNzd4Mm5MNw8ft+w
 FhQW6rnfAr8QEOUf97+j5nl6qBWr5/0WPvK11V5pog1m9wCaHZUTIY4z1r+cB1+KGhdPTw+esF4htw/6T5GsEebVZ/z/Aw/2rsLkwSaeIDJzuLd5p30fTZ6s
 YX7+F1YfRyYGmE/XivAfQ2LPAYwj+n7uGd6y0UV7JdY=

On 08/02/2026 22:32, Steven Rostedt wrote:
> On Sun, 8 Feb 2026 21:53:31 +0100
> Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:
> 
>> Otherwise the solution could be to switch according to Linux version
>> between print_args() with and without bft support, basically re-adding
>> the function here:
>> https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/commit/?id=e798103c0815e6642e74d9317c325b2c62681f2e
>>
>> What do you think about it?
> 
> Is the failure found at runtime? That is, the loaded BTF file doesn't
> parse correctly? What is the error exactly?
> 
> I guess if the tep_btf_print_args() fails, it should just print the raw
> args then.

Oh, I've forgotten to post the build failure, here it is and it's due to
dealing with different Linux versions:
[8/40] Compiling C object src/libtraceevent.so.1.9.0.p/trace-btf.c.o
FAILED: [code=1] src/libtraceevent.so.1.9.0.p/trace-btf.c.o
/home/giuliobenetti/git/upstream/test-libtraceevent/bootlin-armv5-uclibc/host/bin/arm-linux-gcc 
-Isrc/libtraceevent.so.1.9.0.p -Isrc -I../src -Iinclude -I../include 
-Iinclude/traceevent -I../include/traceevent -fdiagnostics-color=always 
-Wall -Winvalid-pch -std=gnu99 -O3 -D_GNU_SOURCE 
'-DPLUGIN_DIR="/usr/lib/traceevent/plugins"' -D_LARGEFILE_SOURCE 
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -O2 -g0 -fPIC -MD -MQ 
src/libtraceevent.so.1.9.0.p/trace-btf.c.o -MF 
src/libtraceevent.so.1.9.0.p/trace-btf.c.o.d -o 
src/libtraceevent.so.1.9.0.p/trace-btf.c.o -c ../src/trace-btf.c
../src/trace-btf.c:60:10: error: ‘BTF_KIND_FLOAT’ undeclared here (not 
in a function); did you mean ‘BTF_KIND_CONST’?
    60 |         [BTF_KIND_FLOAT]        = "FLOAT",
       |          ^~~~~~~~~~~~~~
       |          BTF_KIND_CONST
../src/trace-btf.c:60:10: error: array index in initializer not of 
integer type
../src/trace-btf.c:60:10: note: (near initialization for ‘btf_kind_str’)
../src/trace-btf.c:60:35: warning: excess elements in array initializer
    60 |         [BTF_KIND_FLOAT]        = "FLOAT",
       |                                   ^~~~~~~
../src/trace-btf.c:60:35: note: (near initialization for ‘btf_kind_str’)
../src/trace-btf.c:61:10: error: ‘BTF_KIND_DECL_TAG’ undeclared here 
(not in a function)
    61 |         [BTF_KIND_DECL_TAG]     = "DECL_TAG",
       |          ^~~~~~~~~~~~~~~~~
../src/trace-btf.c:61:10: error: array index in initializer not of 
integer type
../src/trace-btf.c:61:10: note: (near initialization for ‘btf_kind_str’)
../src/trace-btf.c:61:35: warning: excess elements in array initializer
    61 |         [BTF_KIND_DECL_TAG]     = "DECL_TAG",
       |                                   ^~~~~~~~~~
../src/trace-btf.c:61:35: note: (near initialization for ‘btf_kind_str’)
../src/trace-btf.c:62:10: error: ‘BTF_KIND_TYPE_TAG’ undeclared here 
(not in a function); did you mean ‘BTF_KIND_TYPEDEF’?
    62 |         [BTF_KIND_TYPE_TAG]     = "TYPE_TAG",
       |          ^~~~~~~~~~~~~~~~~
       |          BTF_KIND_TYPEDEF
../src/trace-btf.c:62:10: error: array index in initializer not of 
integer type
../src/trace-btf.c:62:10: note: (near initialization for ‘btf_kind_str’)
../src/trace-btf.c:62:35: warning: excess elements in array initializer
    62 |         [BTF_KIND_TYPE_TAG]     = "TYPE_TAG",
       |                                   ^~~~~~~~~~
../src/trace-btf.c:62:35: note: (near initialization for ‘btf_kind_str’)
../src/trace-btf.c:63:10: error: ‘BTF_KIND_ENUM64’ undeclared here (not 
in a function); did you mean ‘BTF_KIND_ENUM’?
    63 |         [BTF_KIND_ENUM64]       = "ENUM64",
       |          ^~~~~~~~~~~~~~~
       |          BTF_KIND_ENUM
../src/trace-btf.c:63:10: error: array index in initializer not of 
integer type
../src/trace-btf.c:63:10: note: (near initialization for ‘btf_kind_str’)
../src/trace-btf.c:63:35: warning: excess elements in array initializer
    63 |         [BTF_KIND_ENUM64]       = "ENUM64",
       |                                   ^~~~~~~~
../src/trace-btf.c:63:35: note: (near initialization for ‘btf_kind_str’)
../src/trace-btf.c: In function ‘btf_type_size’:
../src/trace-btf.c:115:38: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct btf_decl_tag’
   115 |                 return size + sizeof(struct btf_decl_tag);
       |                                      ^~~~~~
../src/trace-btf.c:119:38: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct btf_enum64’
   119 |                 return size + sizeof(struct btf_enum64) * 
BTF_INFO_VLEN(type->info);
       |                                      ^~~~~~
[9/40] Compiling C object plugins/plugin_kmem.so.p/plugin_kmem.c.o
[10/40] Compiling C object plugins/plugin_tlb.so.p/plugin_tlb.c.o
[11/40] Compiling C object plugins/plugin_net.so.p/plugin_net.c.o
[12/40] Compiling C object src/libtraceevent.so.1.9.0.p/parse-utils.c.o
[13/40] Compiling C object 
plugins/plugin_sched_switch.so.p/plugin_sched_switch.c.o
[14/40] Compiling C object samples/test-event.p/test-event.c.o
[15/40] Compiling C object plugins/plugin_scsi.so.p/plugin_scsi.c.o
[16/40] Compiling C object src/libtraceevent.so.1.9.0.p/event-parse-api.c.o
[17/40] Compiling C object plugins/plugin_function.so.p/plugin_function.c.o
[18/40] Compiling C object src/libtraceevent.so.1.9.0.p/trace-seq.c.o
[19/40] Compiling C object plugins/plugin_kvm.so.p/plugin_kvm.c.o
[20/40] Compiling C object src/libtraceevent.so.1.9.0.p/event-plugin.c.o
[21/40] Compiling C object src/libtraceevent.so.1.9.0.p/kbuffer-parse.c.o
[22/40] Compiling C object src/libtraceevent.so.1.9.0.p/parse-filter.c.o
[23/40] Compiling C object src/libtraceevent.so.1.9.0.p/event-parse.c.o
ninja: build stopped: subcommand failed.
make[1]: *** [package/pkg-generic.mk:273: 
/home/giuliobenetti/git/upstream/test-libtraceevent/bootlin-armv5-uclibc/build/libtraceevent-1.9.0/.stamp_built] 
Error 1
make: *** [Makefile:83: _all] Error 2

Giulio
