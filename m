Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0362040B6
	for <linux-trace-devel@vger.kernel.org>; Wed, 14 May 2025 07:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209086; cv=none; b=cztMrvpKKjAK/LW3J3JO2k9I833sead4Npc3IG9TaES10vroZrf1cYPcF4X+Q2/BMvoK/CObnn5HB+pNtYAceHhxNYFeFqvyurvCyNGc4NEnIi9KtT4L81veYPI92KE9uCAKckS6KIYaKPjEw8PWjIdwrXD8r3kUVZvaIaai4Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209086; c=relaxed/simple;
	bh=C2GmyhPavrjLAkp1T4hzH95bJoZM5eoFUKCT1yGkjqU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KMErOl0RG+maTLXci7dGmlnPGIW6QcQNJCFQdGpBSjvttwG9/N2UV13DcgEuiRIcdqsz4nmWDEsN3cb+Obv3W1aHjyu1Kr40rLSLC8gzSefGOmfh0GWiksBHrzHyvl3BH11qdT+nGz+d8QfRkybPpSUiVrW9tNfZo3OzepgqPp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CEMK7kaa; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CEMK7kaa"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E6IeRP026609;
	Wed, 14 May 2025 07:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=C2Gmyh
	PavrjLAkp1T4hzH95bJoZM5eoFUKCT1yGkjqU=; b=CEMK7kaa2bZ/H8SZ42tSwD
	ZEE/QkWSpEpq8VsKtKdRNUeIFKWmKGamdxZIEP8wrzjd7TS1DbIImr2qHdOWq0nk
	Rtbs7o/8e5w2FnIIazCBjisZxRqExpTgO/2n9oHelZKJhtyg3+cefBRiQyfrDlgU
	OMN2B4dkmUG4jdyS8Sbqw6LH8epBYQJBPBrj3s3eWs/ZUCN1Idt2h4J/6CQICS06
	IaiTe3BY0ycEQ+cSxh0fxYphd8cj3jj5wHAhExpkPoxcXacAkCGtoo0IMAZF5uLi
	LPB/dSy3M2ivc1EzSxZ/qSngIBLkDl86sCeWvXnqoUTy8VIci2F8AoqW60SaRjGA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mnst0cyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 07:51:22 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54E66sl2021459;
	Wed, 14 May 2025 07:51:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfrk1n8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 07:51:21 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54E7pHIP46006596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 07:51:17 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DF8D2013F;
	Wed, 14 May 2025 07:51:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9695420144;
	Wed, 14 May 2025 07:51:16 +0000 (GMT)
Received: from [127.0.0.1] (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 07:51:16 +0000 (GMT)
Message-ID: <bab0be078205af4c8d38e8211accc402ac6b6a4a.camel@linux.ibm.com>
Subject: Re: [PATCH] libtracecmd: Support changing /proc/kallsyms
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>
Date: Wed, 14 May 2025 09:51:16 +0200
In-Reply-To: <20250416231325.14113-1-iii@linux.ibm.com>
References: <20250416231325.14113-1-iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fiJ53DOtqZIUHLWj1iYyp2z8ic_9uw0v
X-Authority-Analysis: v=2.4 cv=V+590fni c=1 sm=1 tr=0 ts=68244b7a cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=yD5Xa3RlGoCXCZpE41AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: fiJ53DOtqZIUHLWj1iYyp2z8ic_9uw0v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA2NSBTYWx0ZWRfX/Pm2lAWp1TFE 735YMdYzUEomXXxiXvnM+mxpWcgniB6F2nRBW83uImIsx5ce0McOQw3Z89sjzmdl3kZYICCZd6d SqF32bsfn7qaDDAUwnhn7uDBiKzpxH0+PX/qla0MnDFehq1/s82CZ8+ZH0zDs/w+LOnQAlE86Jo
 m2ZP0pLaM1+4Db6B7BLpukMYBjqIyZTnZpsuBCOe22H5s+Y2siPVgUoflXMA0YCCS/VhYr+30wK Iz3xu+z/4aaJ6QeKMsBGrstxKfgxV8wfsB2hb6a2o3q6GUlt2UlKueg086+q6zYr7q9k1Xgom6r 9HTS8fBGSpLjD4ZTGLyekSH4YbazrOP+1LmmpqRtxvQzLWzOW9gI0BgNWYh3+f4Oaya901CaHGt
 DqfVCKNBmqdhYvvLDF/ZzR1L2aaJx7P++2ujVzJCl4HkB00T1ahMf9T0dD7QDgy8aoxAhLj0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_02,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=942 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140065

On Thu, 2025-04-17 at 01:13 +0200, Ilya Leoshkevich wrote:
> Running BPF selftests under trace-cmd intermittently fails with:
>=20
> =C2=A0=C2=A0=C2=A0 error in size of file '/proc/kallsyms'
>=20
> This is because these selftests load and unload BPF programs.
> bpf_prog_put() uses workqueues and RCU, so these programs disappear
> from /proc/kallsyms after a delay.
>=20
> trace-cmd reads /proc/kallsyms twice: the first time to compute its
> size, and the second time to copy it into the trace file. If the
> resulting sizes don't match, which is what happens in this case,
> recording fails.
>=20
> Fix by first copying /proc/kallsyms into a temporary file, and then
> into the trace file. An alternative would be to read it into a
> malloc()-ed buffer, but this would increase trace-cmd memory usage,
> since /proc/kallsyms can be a few dozen megabytes large. In case
> /tmp is tmpfs, both solutions are almost equivalent.
>=20
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
> =C2=A0lib/trace-cmd/trace-output.c | 66 ++++++++++++++++++++++++++++-----=
-
> --
> =C2=A01 file changed, 52 insertions(+), 14 deletions(-)

Gentle ping.

