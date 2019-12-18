Return-Path: <SRS0=nq8z=2I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962AAC43603
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Dec 2019 15:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ED9C2176D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Dec 2019 15:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLRP0q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 10:26:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbfLRP0p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 10:26:45 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIFMdiS114630
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Dec 2019 10:26:45 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wy7ub68b0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Dec 2019 10:26:44 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-trace-devel@vger.kernel.org> from <svens@linux.ibm.com>;
        Wed, 18 Dec 2019 15:26:42 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 15:26:41 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIFQerW45482248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 15:26:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA41152050;
        Wed, 18 Dec 2019 15:26:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id BEBD652057;
        Wed, 18 Dec 2019 15:26:39 +0000 (GMT)
Date:   Wed, 18 Dec 2019 16:26:39 +0100
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] ftrace: fix endianness bug in histogram trigger
References: <20191218074427.96184-1-svens@linux.ibm.com>
 <20191218074427.96184-4-svens@linux.ibm.com>
 <20191218102423.755eefdc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218102423.755eefdc@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-TM-AS-GCONF: 00
x-cbid: 19121815-0012-0000-0000-000003763AFC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121815-0013-0000-0000-000021B22A4E
Message-Id: <20191218152639.GA8508@tuxmaker.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_04:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180126
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Wed, Dec 18, 2019 at 10:24:23AM -0500, Steven Rostedt wrote:
> On Wed, 18 Dec 2019 08:44:27 +0100
> Sven Schnelle <svens@linux.ibm.com> wrote:
> 
> > At least on PA-RISC and s390 synthetic histogram triggers are failing
> > selftests because trace_event_raw_event_synth() always writes a 64 bit
> > values, but the reader expects a field->size sized value. On little endian
> > machines this doesn't hurt, but on big endian this makes the reader always
> > read zero values.
> 
> Does this fix make the other one obsolete?
> 
>   https://lore.kernel.org/r/20191211110959.2baeb70f@gandalf.local.home

No, that's a completely different issue, so we need both.

Regards
Sven

