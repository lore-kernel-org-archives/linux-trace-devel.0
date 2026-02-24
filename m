Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C3C3A9624
	for <linux-trace-devel@vger.kernel.org>; Tue, 24 Feb 2026 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771952738; cv=none; b=bWMBLeb84l+P9N1v965DZzgMWfeS5SKsTLaUFy7hLTKSFfc2UHva3HCcGgCQN6mZwbSC8vsfb0wSbIpHkyXslvsur2+C23lUlRyrIr3GABaK+FaXNoJCFqqVjPD1vBBdvFCpwWZFFT6gs77ml6vf//I6nTI9DEYbS99ypNuG/kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771952738; c=relaxed/simple;
	bh=jBDyM9RPXlEsJscZOBHYMPRK61g3XgQ/UVvd6oQenCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mnn8KxH8Ff59kROpfN44uxNT/vwUETqqmL6HAgGEFH2eNrAms2IaiE+NcK8mxBp90EA6a7BmlPFPGYvdUEeH4ijlIPQXJPe91vV2imsusrl+Ax5jT2COK1OWzUHehvK3XE8WjKBKP3ezGPZJK98D6l/itpLot6fMjgB5iP16Yos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VFlEbrZh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VFlEbrZh"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61O9GWHP2894740
	for <linux-trace-devel@vger.kernel.org>; Tue, 24 Feb 2026 17:05:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=xqT5Joe8QAsQldd7hn93Pvm28upqCi1cMvRcxnhma
	N0=; b=VFlEbrZh7z4ggIZN+aOt21Pc+XcZY/aRXcxnwB8zNQOFaUifc00reDy6t
	MiURMWQzYA9qubFo8BCD1KKsKrPCEv+wN/nM7FIMssPtATuoJNwmwg56Sm6c6O58
	Rb0CBUlaZaolG5lag/LzkmwakLU9Qw5/VP6CI5KDT/tWk67DPmBWN98MbHrLfhe5
	/4rH0hWgLuTTu8l77TxxF8yp1bcvTH9NkHNXoT+hNIxJssL2kiQVUkosJEioermF
	8UfV/xJI2tL/HuMfDGJa7cph1M0eqFBATYkUnkd8NvumblAOArYUgAthU0ZpZAbT
	pzhk9D+M4k4eSl4iSIIpIRsbAFaTA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf471vnex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-trace-devel@vger.kernel.org>; Tue, 24 Feb 2026 17:05:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61OGUEKg015970
	for <linux-trace-devel@vger.kernel.org>; Tue, 24 Feb 2026 17:05:36 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfq1shuk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-trace-devel@vger.kernel.org>; Tue, 24 Feb 2026 17:05:36 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61OH5Wop29426148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 17:05:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6893B20043;
	Tue, 24 Feb 2026 17:05:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2792720040;
	Tue, 24 Feb 2026 17:05:32 +0000 (GMT)
Received: from machiner.ibm.com (unknown [9.111.4.35])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Feb 2026 17:05:32 +0000 (GMT)
From: Ciunas Bennett <ciunas@linux.ibm.com>
To: linux-trace-devel@vger.kernel.org
Cc: Ciunas Bennett <ciunas@linux.ibm.com>
Subject: [PATCH] kernelshark: Fix TEP filter array parsing logic
Date: Tue, 24 Feb 2026 17:05:25 +0000
Message-ID: <20260224170528.728883-1-ciunas@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ojE_zM4nuxFI_GhWcYq3vMxCujGjk8Ou
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDEzOSBTYWx0ZWRfXxJ9sG2BIwp4u
 hY7Jyb/B6WIDQYQEqBAmLPWtL/4j9vJjLydwubbaOB8444iNY3gzfW5VtaIsu1vD8AzjFK+TCeI
 BiluxNZCFF/Zs7n+4RxtOKkCQdZ9xNl6tbpchpRfsbu+/KNbNLMNBsMoTlMyTvpb387GCj1MkcW
 ZSpxOE78FqL5ToLJXudHnNGiRVRPBNacFzNYKhJuz8s3VZTnHq28hJt7EM8u9W0GweGVbg51ZyG
 DPXguI6eX9qvVmL7fkLDuZe/KDz45vnVUtEwJOkpag3wIP9ewkg0A23Bh5XabOP7aRMzJe/DlO1
 Ws1vhPdbi3Iz8gVZS8yIhHwwvg8Edo50YAGMJ2VvvoJhqqDflHJfYL7ps4nKzRooRaqbQ2rMAr3
 GTDuoNxmtDdjGRI8juZrxnJV41iTTWd3jplRlqU4dIbnsB+ZNc7qPJ8X00mz7txyBHr7OpB/YUA
 Ry9T/R9dkLhiv9d9xgg==
X-Authority-Analysis: v=2.4 cv=R7wO2NRX c=1 sm=1 tr=0 ts=699dda61 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=lUvPhnKy8L6yMxmQRDoA:9
X-Proofpoint-GUID: ojE_zM4nuxFI_GhWcYq3vMxCujGjk8Ou
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602240139

When saving a session with more than a single TEP advanced filter,
KernelShark triggers a json-c assertion:

"json_object_array_get_idx: Assertion
`json_object_get_type(jso) == json_type_array' failed."

This is caused because the code reuses the `jfilter` variable inside
the loop to fetch each array element:

    jfilter = json_object_array_get_idx(jfilter, i);

This overwrites the original array object. On the next iteration,
`jfilter` is no longer a json_type_array, causing the assertion.

Fix this by introducing a temporary variable `jitem` to store each
array element, leaving `jfilter` to point to the actual array.

Signed-off-by: Ciunas Bennett <ciunas@linux.ibm.com>
---
 src/libkshark-configio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
index 88c2c9a..568ec73 100644
--- a/src/libkshark-configio.c
+++ b/src/libkshark-configio.c
@@ -1528,7 +1528,7 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx, int sd,
 static bool kshark_adv_filters_from_json(struct kshark_data_stream *stream,
 					 struct json_object *jobj)
 {
-	json_object *jfilter, *jname, *jcond;
+	json_object *jfilter, *jname, *jcond, *jitem;
 	int i, length, n, ret = 0;
 	char *filter_str = NULL;
 
@@ -1548,10 +1548,10 @@ static bool kshark_adv_filters_from_json(struct kshark_data_stream *stream,
 	/* Set the filter. */
 	length = json_object_array_length(jfilter);
 	for (i = 0; i < length; ++i) {
-		jfilter = json_object_array_get_idx(jfilter, i);
+		jitem = json_object_array_get_idx(jfilter, i);
 
-		if (!json_object_object_get_ex(jfilter, "name", &jname) ||
-		    !json_object_object_get_ex(jfilter, "condition", &jcond))
+		if (!json_object_object_get_ex(jitem, "name", &jname) ||
+		    !json_object_object_get_ex(jitem, "condition", &jcond))
 			goto fail;
 
 		n = asprintf(&filter_str, "%s:%s",
-- 
2.53.0

