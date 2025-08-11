Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9532DC342
	for <linux-trace-devel@vger.kernel.org>; Mon, 11 Aug 2025 08:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754900569; cv=none; b=Qif65HjkitlwftTzA592U+JoGkj/ZfoxEonrV8PtBe0MshvDGbo5YBMzMKmIg3Lwwf3MBQ9OPSZUMkFYuWz6EJZq3RtCdufkEsZKrEHIAwsnrwNGT6BHqZ39ZwCciTT0J5HkrPc5yApAheZ4IcjXSGmMXyoNH6K089jd+wjeAL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754900569; c=relaxed/simple;
	bh=i8A7sKulOXPQD+tI+U8j5j1BVlriazQe4bI783GlT+A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OkozrrUNL01f8o0LlKYw9ncs0Nve4vNPnOw5XgppS+HbU8uK3kLtRz31LX/wTEGlT1WSYI087DvZDHxTz2kW9MdAm2g41w+u5PlHus1XfQ/WWk1kvUoghYYWWzmfB+XTgXrSrlXUQtoTPHIJCh1SLLICIqCyQan4qEaoTocfBGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kDtiEveg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kDtiEveg"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57AJrJtY017895;
	Mon, 11 Aug 2025 08:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=i8A7sK
	ulOXPQD+tI+U8j5j1BVlriazQe4bI783GlT+A=; b=kDtiEvegAlSmd6rrJc94vf
	yYKeaEOXROVKGKqLt1PAY53Qm81ZixRoSL6okc74cEg0mFN5NOgHBWRHqNiL9BHU
	aZ9cFbCSioUYijFa8+lErp8OyIR9jscY7HZAOt81ZeN61hABrdLfQ1U+cpJKCJ5W
	6X9hJ3NzEF9nLdn8mAgh93A3+o2b4MBEbZFhsvnHQ4XHyzdgvgZc+jR561kQHbwH
	2ViXwjmsGq0uMl7FVVZTFuRSlexxol2hieuDggCOj7N2XodmhTRaFsJtAKQYF0cd
	Tsg2ChhVivrxTCqgqOXSnkJC4DvrZzT5frM+9WPJf8kiilsna6Y7GoRoFZ4MqISA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrnr4vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 08:22:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57B4X9mR010832;
	Mon, 11 Aug 2025 08:22:43 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48egnud6td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 08:22:43 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57B8Mdkb17629520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 08:22:39 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C055220040;
	Mon, 11 Aug 2025 08:22:39 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 641952004B;
	Mon, 11 Aug 2025 08:22:39 +0000 (GMT)
Received: from [127.0.0.1] (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 Aug 2025 08:22:39 +0000 (GMT)
Message-ID: <f5ad96bcbf5d94a4579b7a3be21e4048bd7f2681.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/2] libtracecmd: Support changing /proc/kallsyms
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>
Date: Mon, 11 Aug 2025 10:22:39 +0200
In-Reply-To: <20250711132802.1781-1-iii@linux.ibm.com>
References: <20250711132802.1781-1-iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA1NSBTYWx0ZWRfX7dlRBYROz03F
 CZRbccRbRcZgb/1zLu+RCmxMhTTCT9IWpwYF2mPC+nVBcsY9nspzqKfsgsRgrewqlIC24vhJHV3
 kkD2aHGgUrfIskW+y1xyK9Lb00a2obtlcqRqVp2fI9KD+Tq7E8NfZz3Yx4jfMKYlSt+8gNfZzE+
 Lh8T/Ps+pNdYmo8++GnaJIJNEXRtG4+zamWnjiXOXIHI0SPFTxCNZurLK1Y8ReX2E64ETO8iEPj
 7FTOmVB8nT1djZmeNqoPLRJbgZHHQ0OmRh8b8Z/AyhscOu+p1iuzH3rzlB5KP4XG3gOeNHNr/dh
 mERTvurj5JDsmesyfOSu5J+2DDOEXrxyMbzotVCrjllYQOoKVVcWbGqdhSjAHapzRFV03KxLyVv
 dF2YhMxBgMkEHN5ql93h3tpFqeK8Fc8nTMHZn1OA9Hq3CYcR+R52F06PVv2tLeRdcpdDzdS0
X-Authority-Analysis: v=2.4 cv=GrpC+l1C c=1 sm=1 tr=0 ts=6899a854 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=MLyIqMX3CaRT8rIYaAoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ID4xUiFzIPWdwt1xD_asQhZEpnqy4gvS
X-Proofpoint-ORIG-GUID: ID4xUiFzIPWdwt1xD_asQhZEpnqy4gvS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_01,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=850
 malwarescore=0 clxscore=1011 adultscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508110055

On Fri, 2025-07-11 at 15:25 +0200, Ilya Leoshkevich wrote:
> v2:
> https://lore.kernel.org/linux-trace-devel/20250602214154.446881-1-iii@lin=
ux.ibm.com/
> v2 -> v3: Add a comment and some newlines (Steven).
>=20
> v1:
> https://lore.kernel.org/linux-trace-devel/20250416231325.14113-1-iii@linu=
x.ibm.com/
> v1 -> v2: Rewrite the size instead of reading the file twice
> (Steven).
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Turns out exposing=
 do_lseek() is not necessary, since
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 everything is in t=
he same C file.
>=20
> Hi,
>=20
> this series fixes tracing in presence of frequent BPF or kernel
> module
> loads/unloads. Patch 1 is a small required improvement; patch 2 is
> the
> actual implementation.
>=20
> The problem can be reproduced like this:
>=20
> =C2=A0=C2=A0=C2=A0 # while true; do rmmod loop; modprobe loop; done &
>=20
> =C2=A0=C2=A0=C2=A0 # while trace-cmd record -p function_graph /bin/true; =
do :; done
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 plugin 'function_graph'
> =C2=A0=C2=A0=C2=A0 libtracecmd: Invalid argument
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error in size of file '/proc/kallsyms'
> =C2=A0=C2=A0=C2=A0 trace-cmd: Invalid argument
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Error creating output file
>=20
> Best regards,
> Ilya
>=20
> Ilya Leoshkevich (2):
> =C2=A0 libtracecmd: Support querying position within a new compressed
> block
> =C2=A0 libtracecmd: Support changing /proc/kallsyms
>=20
> =C2=A0lib/trace-cmd/trace-compress.c |=C2=A0 5 ++++-
> =C2=A0lib/trace-cmd/trace-output.c=C2=A0=C2=A0 | 38
> +++++++++++++++++++++++++++++++++-
> =C2=A02 files changed, 41 insertions(+), 2 deletions(-)

Gentle ping.
