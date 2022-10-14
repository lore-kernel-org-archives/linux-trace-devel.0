Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5858EC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Oct 2022 15:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiJNPRH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Oct 2022 11:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJNPRF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Oct 2022 11:17:05 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B811C77F9
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Oct 2022 08:17:04 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=WgUBlcZBrCyN5O1r2LJIq+1WwsS9ImqYytdyUtB06udVLWLk+DD23WTDtcwLos2uhRG/fnyhjGFLmbgyBELOkRciaQdqEsgJT4/SEVlDsJtlbuJ9TbbGMPbrFy+06/9+R96TWJk7AZ0NjZMo750MEfUunsPgNXmPadbs//2vdCL83py5M4igWAjl3+8+xUZisDjaQH6vMn7yNoPHDCrDeBKZDfsCd+VCurhOzhvXAyXpRngnldret8G3IeXTBEkB/K3BWOSa3wjnnF0CCzMmco9F0UlmwjvdoIUjr8/JSyz0el7nh8CB5pQnK2BBOBQeOvjtN8XwFUwRtp8e80LH5w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avYbY70WlA5jTpxNTJDl95FAfwNEijJbz+NxPpeBRjw=;
 b=XORJ1vP2zskqj/rqQ21JmWKQcGv4NVK9LVdOGNj1Hea2Q8ZKZQiVZO4GasAUiBnLMT97fGm6b1bvAQWbmX2d9ZmDot0Jdzex4jqnyE7kU3U0rc+gT8QJB5czFFCwpyHi3lHJXGpqvs1V6TKZ4Wdba0OmrAtxDwZhSVUgY4p163xlDellnrh83QegFcWmFWNHQDr0+96GFKOVccd0vhLmYA1+MTtVhuevvC0sKLvPmqVl/A/oN9lLfkj0IfOsZlWsUmOvYp2Ub4XA0l7T/Gmr9evznm9OLrh5vU82uwy3kDBYsowJujEb3fsCes2RR79XGadhBixPvvPJAyv09lRTLw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avYbY70WlA5jTpxNTJDl95FAfwNEijJbz+NxPpeBRjw=;
 b=KzWoRs9gljubiq4v8RBVEIuYnsIZ07lwHJAshR+QYspB3wtnsthIfp2YMhGoSNDK/0zsIu1Ka0dwlc+85NK949sc9YaIcYG90rGtJjbqCAsnwJMWYFUbk0RbnCE2vfQsGJAl9+5xU/akfY8Ei33usIXu6bK6ErBitMmLrfqqtCs=
Received: from DB6PR0202CA0003.eurprd02.prod.outlook.com (2603:10a6:4:29::13)
 by DB8PR08MB5500.eurprd08.prod.outlook.com (2603:10a6:10:11e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 14 Oct
 2022 15:16:56 +0000
Received: from DBAEUR03FT021.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:29:cafe::56) by DB6PR0202CA0003.outlook.office365.com
 (2603:10a6:4:29::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15 via Frontend
 Transport; Fri, 14 Oct 2022 15:16:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT021.mail.protection.outlook.com (100.127.142.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.10 via Frontend Transport; Fri, 14 Oct 2022 15:16:56 +0000
Received: ("Tessian outbound 58faf9791229:v130"); Fri, 14 Oct 2022 15:16:56 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d54392b89c18af74
X-CR-MTA-TID: 64aa7808
Received: from d8c89c5b81c7.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id B0F04308-7925-4BDC-B283-A5AB775F024E.1;
        Fri, 14 Oct 2022 15:16:50 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d8c89c5b81c7.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 14 Oct 2022 15:16:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxA6YXTwLv0k3/t6aOi4hCxbpXtyc2xKmulR0vD7hAfBtipElstkgljqQAEArF4+F1fkyZES1VfIhhquS9dDnc7QT4UJKMWl6CUCSECdqbJwqnIVA/kT1C1gdOHZxv5u7FGhFKmnCmM25dC0qM8hfL54Q403G4VaXVMVfNz64NSR/aD/rkqYchi3fLYgCid8MxDgQhtpe4xf+YEKYDzRykTmDViFA1tQEzYs4GQEmf40ZKKWgtOd7tR4yuoZ/cocHgMx9PJjCeFHlp3BwiS+dNSUwZrQ3oV5SrLNf2nw90R1U/GNA8uqQJE310XX4pw8qWjgskiqAwuJR40PbYqoWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avYbY70WlA5jTpxNTJDl95FAfwNEijJbz+NxPpeBRjw=;
 b=VnD11HP4Q0ZtYQ3Rk9XX/kZBLZ5M1ntTKZg/+djcxfShgzHx41oKmoJq0HPS8X2kQIwM8LjaKSTHHB68w84wyf3hFWojWAAgTue8YKUEFW/Jb3dFdf7/Qg43jGlsJsx1AEWkL82L4kGwp/FOYlBuu04AeSk0mOTqr4j0nFScQtpsts0wEtwfbgfpk1NHQYRuQzYBp0sOiZXSvdxfULzcU/nSNDa/EARiMYHXBaeER7XICk6CtWgaPqS5wTBzL1y5IlwpPaMZobZVI7twFdLU4alUFY1KSsxhbwHHaAaDVt2v9Woj4P5f2rC7/wnMP0nNY0ivF7s/bnMaNDxMW/9nxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avYbY70WlA5jTpxNTJDl95FAfwNEijJbz+NxPpeBRjw=;
 b=KzWoRs9gljubiq4v8RBVEIuYnsIZ07lwHJAshR+QYspB3wtnsthIfp2YMhGoSNDK/0zsIu1Ka0dwlc+85NK949sc9YaIcYG90rGtJjbqCAsnwJMWYFUbk0RbnCE2vfQsGJAl9+5xU/akfY8Ei33usIXu6bK6ErBitMmLrfqqtCs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PA4PR08MB7617.eurprd08.prod.outlook.com (2603:10a6:102:272::12)
 by PAVPR08MB9698.eurprd08.prod.outlook.com (2603:10a6:102:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 15:16:40 +0000
Received: from PA4PR08MB7617.eurprd08.prod.outlook.com
 ([fe80::1df5:94c1:8c7b:690c]) by PA4PR08MB7617.eurprd08.prod.outlook.com
 ([fe80::1df5:94c1:8c7b:690c%4]) with mapi id 15.20.5709.019; Fri, 14 Oct 2022
 15:16:39 +0000
Message-ID: <96dc3f67-5405-c1a4-7c94-a98de3085cc5@arm.com>
Date:   Fri, 14 Oct 2022 16:16:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@goodmis.org
Content-Language: en-US
Cc:     Nikita Baksalyar <nikita.baksalyar@gmail.com>
From:   Douglas Raillard <douglas.raillard@arm.com>
Subject: libtraceevent + Rust
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SN7P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::24) To PA4PR08MB7617.eurprd08.prod.outlook.com
 (2603:10a6:102:272::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: PA4PR08MB7617:EE_|PAVPR08MB9698:EE_|DBAEUR03FT021:EE_|DB8PR08MB5500:EE_
X-MS-Office365-Filtering-Correlation-Id: 6173e0f7-2bce-45e9-b376-08daadf7220c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: uVWw37JkZyWemy/vv1JyoomhzA3npPN0j+pRgpJu2m56dM+ZQ9ZaZlfb3eqffW7r8D4ogy3k+nY2PP6WxEMxVxLHFwopZwZXYoU77F7CUy39xGFcoRCW6Orm2txr3UryuxMh1EqVOsatVHGEaWh57k2Repy1boGGdLn5deqyZtVz0octo+cWIjHMcqzxClP3vDm7iCxYLOT8+r7Esf2cVcHjdx4cvdy4+uvw8h/Yq1jdALq400lPBBTp7+/cVRXDbSOupSq/2Az0tCgvYq0hOlhTSNHiZTVH5G7N67HgJTCsSdgd++E+CnO5aOww4DE2XpmLhetDjqzLIpsplxCum4E+2zy4jdv/tGhVgl6quioixDU908a615WMyYYmmnK6n8tG6HBchSb4ecmjNAty29sodlOsIyUqv2C5uZFkm9HyffRYbIF7Qydfhl3AmilKmHJaTsVFyVoW0YFdoOoDQOXSHHz/h29tAofgShW1sbc2pdAz8pVC+3MNaYj8Cl8pGUU72kMXnN9R5n48uEHlHaIgtK7dffZsCfg8YnoBhrKpDmVsCb2Td4bjB5d6AUPpRGBFdCbvFS7CvOQWQ1yhni4dst95U+FU9q475k1OL4QgKbYh96MnUjjg0d0OANJHXnt26NOzrbjmP/9/ecs4u2S1eDhw0rYzSb30rvYxvhq8GJO4aTiL4Ff651rknwGXNgPbBQWHTAiOffISYA1zM1kCwIUb0pb9S4p7tlQgUgibJzYqjN4voeHzNdbhqUR8eLJxnFsDwKOSiW0IBW0mx4yx7VzPxKB6ZdHyu7jW4nvw6bZWC81XbWRDxi8TE3CG
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR08MB7617.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(2616005)(41300700001)(26005)(66946007)(2906002)(4326008)(66556008)(966005)(86362001)(316002)(6506007)(6512007)(31696002)(6486002)(83380400001)(66476007)(6666004)(44832011)(8936002)(5660300002)(186003)(36756003)(38100700002)(8676002)(478600001)(66899015)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9698
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 77c7eea9-97f1-4213-e948-08daadf71795
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EIOigWdZLGj9MCGUNLFDK1k6SgCe9Vx5DcE/Qt4vkeiAi+BermobnOvF+2gVnxfmxiA9rg6tSUM+T+iac/wQwwPn9aUXyLsIKoQtrw9XAeG7xtfXJSAyCTKJbaT8X3q71X6uKHlu+RnWjNmlLq8+gTXw2BZWqf0ph+thZV0kr7j4YnP+Z8frZ/TQAjQuCQmbIZTHu2O+Zo5HoHZMsb/phIGcc3dXov8pCKlwZSzbgKUe69OgG7NsWbRj4zhx9RpbRkxEws9x5EFDo2LIeB+dWk970OQQyEbcUArTO4JSwuwGSrrjJRC+xsI91yQS+R22V/H+3cG9enqCMx6H2rapWlVNNovwS/zemnJigThqL5id+qXrmDLYPU+ixWN34uKsSfv8c3PP8sACV/5FJOUpaYGBtAHY3QFscWI0Gq3TKKvcMt+1Uu/IyD5eCP44shpee01cQaQtNe3Mo3DvKl+VMFal1RgiiUtz+uwm8UlYQSoM59vdbkzY2TIhrOwUO3OzrOuAhRmeLmbEwnNFkTnqlmcPGGcTAl5Zwk6W6vyZhe9XRPrKL8WW3iZaM/eTpN73JZJMkbcNouFp2mJzYSUuI98pXkkDoChuZ9bjYdDYnqcCLa+Nrdpvv4ZZVDDoUBqafWuH0zAkoh4Gi1XchPw03GffHP62BN1diu651kgUIbhQZzAOFlF8XQBsZ7n5AE5fZrs/BMI4BRyeLLP8LquSz0RjGJS0Y87V/yzftHKS7iIVP6YrUYrD2Xo47HvQBihJ2ivkRavqST6TMyQ2gp2jt/1E/uCiqJNuGbv3h809tZ0233FnHhsMfDPN8CDC9gRBUrJxbqFmYWYs2NaAageiBA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(36860700001)(6486002)(966005)(2906002)(478600001)(186003)(2616005)(6506007)(41300700001)(70586007)(316002)(6666004)(26005)(70206006)(8676002)(81166007)(4326008)(40480700001)(107886003)(40460700003)(356005)(86362001)(31696002)(82740400003)(6512007)(82310400005)(44832011)(8936002)(36756003)(5660300002)(31686004)(47076005)(83380400001)(66899015)(336012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 15:16:56.6131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6173e0f7-2bce-45e9-b376-08daadf7220c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5500
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi everyone,

The idea of having some Rust interop for libtraceevent was floated during t=
he
Tracing Summit that took place this week.

The overall work has two scopes:
     1. libtraceevent: low-level helpers to decode event formats and binary=
 buffer pages.
     2. high level API that e.g. can consume a trace.dat file and expose an=
 iterator API etc.

The current discussion is only about #1. The 2nd part of the work has an
entirely different set of constraints as it would aim at integrating in the
Rust ecosystem as well as possible without trying to replace anything
pre-existent.


* Rust bindings for C code:
     Pros:
         * Faster to implement
         * By construction, any current covered use case stays covered.

     Cons:
         * Less straightforward to build and distribute on crates.io. Curre=
nt
           best practice seems to simply expect the C lib to already be
           compiled/installed on the host system and find it with pkg-confi=
g.
           Otherwise, the lib sources can be bundled and a build recipe
           included. At any rate, it will bring back the daemons of C packa=
ge
           management world where Rust typically only requires "cargo build=
" to
           obtain a working binary.

         * More unsafe code overall when combined with higher level Rust co=
de.


* Rust implementation:
     Pros:
         * Occasion to fix unsatisfactory points in the current API:
             * Some inefficiencies due to looking up fields by name mention=
ed
               by Steven (correct that if I did not get it right).

             * Some unsatisfactory naming convention (Steven).

             * Event format is hard to parse as lots of event strongly
               depends on the format string to specify the actual type. E.g=
. The
               print event uses unsigned long for "ip" and then casts to (v=
oid*)
               in the format string. sched_switch or mm_page_alloc require =
even
               more advanced C parsing power to extract info necessary to
               correctly/usefully represent the state type in most language=
s.
               This might be fixable with more codified best practices and
               fixing existing trace events, but we would still need to dea=
l
               with the existing situation for a few more years at best.  A=
 new
               API could merge the type info from the parsed print format w=
ith
               the other "ABI info" to expose a richer representation to
               consumers.

         * Can be used by higher level Rust code, preserving soundness
           guarantees end to end.

         * Can open new use cases such as:
             * Likely easier to maintain Python bindings using e.g. PyO3
             * Good WASM support is something the Rust community cares abou=
t, so
               that might open an avenue for new trace visualization tools.

     Cons:
         * More work than just making bindings for existing C code.
         * Portability: is there any architecture not currenlty supported b=
y
           Rust we care about ?
         * New toolchain required to build the code. rustup solves that iss=
ue
           very well though.

     Possible cons requiring a prototype to check:
         * If we aim at 100% API/ABI compatibility with current libtraceeve=
nt,
           this may force Rust code into very non-idiomatic code that may a=
ffect
           the benefits of the language.

         * While it can still be exposed to C code, some soundness
           guarantees will likely be lost in passing: Rust ref to C pointer
           conversion is statically lossy. Having a func implemented in Rus=
t
           does not magically make consuming C compilers smarter and able t=
o
           check for memory safety. The improvement would only be inside th=
e
           implementation itself, but if we expose relatively simple low le=
vel
           helpers the advantage is decreased.


I'm sure I missed some things, so let's use this thread to get a better vie=
w of
where to head next.

Steven also made a twitter poll on the matter:
https://twitter.com/srostedt/status/1580589911706521600


Thanks,

Douglas

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
