Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A3230BC9
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Jun 2025 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876721; cv=none; b=TLtwKKnQsZ105vyo0ZEwW32ahLtW8SQFmSH4xir/mcBbghD5YPzLa4QCzxJ5CTIs03quQ/OY2Ja8I0B0LQBOlxlgoMpjXXyO4W2nQbQikmnNhQIueskzvxd+1ORk/vg+R6lg4iu9k2geJ9ep7I5LOS6E7h/5WqPPcCnRO5KRDRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876721; c=relaxed/simple;
	bh=VpK2w/5TZYW+rAjoT7Kjg2eAPewvoCLx58loZyLuP5U=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=nAepu/2mjq3D1aI0KZiqn8xmeJbW8NH0IvhjFDkVgLJRHk82aZHPlJGFZLdqVwD/HCux8ZgSr+Va3nzM+8IGlZ5IPDNeuCEGzvXlbYPaEM7NgLiFksyk12pAcrGBAAopTRzBjUVVaXbS+qTcmCIITOnrLd+6NZoPfdS6iJekt68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dpcM+0Ks; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dpcM+0Ks"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552Ab8iX032423;
	Mon, 2 Jun 2025 15:05:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8SsuvO
	XwHZi42zBo4dhFNTVxpIKqZXAS+kGir+4nSvE=; b=dpcM+0KscHFeu6hteqWg6n
	0hvMxgj35+WwBx6YwxkHRElE5IKmjQsZEwa3DbWEDGdjfY9/yhdn+CiOrVuqqGyx
	e6sE/4DWGKVe1VQsdalktoF3vYBxoxpf5HFNFtCVC3EtF0JsfOXX+f4ZVvJa2Xqm
	UbmPefowvYn8Gv6VL4vuOhjfdOC0ymgIlxIpcFcvN8M+Laol+HwQdoAZ7eC7DAcN
	WKHrmWmqKu5HDMDMRcpp/g/Oe51ygT9a+oo5vnVN79LOYn1FTY2Fnl5F7dCLSEDM
	N5U1Ws94SZQWhaJEfe6R2+e8zE0inPJsA+VWYRJ3nMRlzQ8Q9FsjDLCsa2rEDTtw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 470mr6ndqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 15:05:16 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 552EvHMu024754;
	Mon, 2 Jun 2025 15:05:16 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470dkm6ksm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 15:05:16 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 552F5EZA29295194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Jun 2025 15:05:14 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88E0E58065;
	Mon,  2 Jun 2025 15:05:14 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3670458064;
	Mon,  2 Jun 2025 15:05:14 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Jun 2025 15:05:14 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 02 Jun 2025 17:05:13 +0200
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>
Subject: Re: [PATCH] libtracecmd: Support changing /proc/kallsyms
In-Reply-To: <20250530164502.4adf0c06@gandalf.local.home>
References: <20250416231325.14113-1-iii@linux.ibm.com>
 <20250530164502.4adf0c06@gandalf.local.home>
Message-ID: <a6def6ddb25d2fcb1b01abcb83c62b8c@linux.ibm.com>
X-Sender: iii@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=I99lRMgg c=1 sm=1 tr=0 ts=683dbdac cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=RbmJXl-PEg4nEvXwzQ4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: KbWxScEyf8f8165sSJ-nAsyg1UOJ45gp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDEyMyBTYWx0ZWRfXxOz8t8XRI39E keM0/mpgB+tCBNPfQJYgoTKCmsw6Sw9ROvMiThXxCOMzKugDMIPyvAcKyyYH56qCOaDFHeAqCYt jbwsn1IDQTiaxg9nQG34ziLwl0VPRwHm7q+3dvJLtla7dgVkkK3eP5KonWzO2uByfxQFRyapn2H
 OmRTsI6liEAayOJZgFDeO9RgljNBjXrTh3ThDuahy8YSC4g9a2Gcbw7FcJJAD4MUn5wzJF3jUvk rhdp0MDeSMoCAN8X+VcQfVoZf5Xj11XvB0yIEfDvif1jMyz6V7iG+tz6SJA2WC1HBJq1F/UwzJk 6FjTs55f6vyEOoW22SCDysRBK5i9+gAbbhlW4v4C4uuK//2TTeq/6LwYYfUfWdul1G7tvDgBW1k
 NK8XXzo2N1lOLok5yW9VWn6KAHrF8+XKQC/DPSkoj+Yi/ru4LgNuhzEXcLgW7WusMScVfZo0
X-Proofpoint-GUID: KbWxScEyf8f8165sSJ-nAsyg1UOJ45gp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_06,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2506020123

On 2025-05-30 22:45, Steven Rostedt wrote:
> On Thu, 17 Apr 2025 01:13:00 +0200
> Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> 
> I finally got some time to look at this. Sorry for the delay.
> 
>> Running BPF selftests under trace-cmd intermittently fails with:
>> 
>>     error in size of file '/proc/kallsyms'
>> 
>> This is because these selftests load and unload BPF programs.
>> bpf_prog_put() uses workqueues and RCU, so these programs disappear
>> from /proc/kallsyms after a delay.
>> 
>> trace-cmd reads /proc/kallsyms twice: the first time to compute its
>> size, and the second time to copy it into the trace file. If the
>> resulting sizes don't match, which is what happens in this case,
>> recording fails.
>> 
>> Fix by first copying /proc/kallsyms into a temporary file, and then
>> into the trace file. An alternative would be to read it into a
>> malloc()-ed buffer, but this would increase trace-cmd memory usage,
>> since /proc/kallsyms can be a few dozen megabytes large. In case
>> /tmp is tmpfs, both solutions are almost equivalent.
> 
> Actually, when compression is set, the file is already read into 
> memory,
> and then it is compressed. In fact, it's allocated twice!
> 
> The size is copied into this temp buffer. I wonder if we could just 
> update
> the size if it is different?
> 
> __hidden long long
> tcmd_do_write_check(struct tracecmd_output *handle, const void *data,
> long long size)
> {
> 	if (handle->do_compress)
> 		return tracecmd_compress_buffer_write(handle->compress, data, size);
> 
> 	if (handle->msg_handle)
> 		return tracecmd_msg_data_send(handle->msg_handle, data, size);
> 
> 	return __do_write_check(handle->fd, data, size);
> }
> 
> Now for the "do_compress" we can just update the handle->buffer[] as 
> the
> size is the first thing written into it.
> 
> For the __do_write_check() we can save the file descriptor location and 
> go
> back and update what was written.
> 
> For the "->msg_handle", for now just error out. Unless you are running 
> bpf
> programs while using trace-cmd on guests or sending off the network?
> 
> -- Steve

Thanks for taking a look.
What you propose should work for me.
Would you mind if I make do_lseek() non-static for this?
And maybe rename it to tcmd_do_lseek().
Touching do_compress/msg_handle/pointer/fd directly feels hackish.
